import { LightningElement, track, wire } from "lwc";
import getProjects from "@salesforce/apex/ProjectTrackerController.getProjects";
import getTasksByProject from "@salesforce/apex/ProjectTrackerController.getTasksByProject";
import createTimeEntry from "@salesforce/apex/ProjectTrackerController.createTimeEntry";
import getRecords from '@salesforce/apex/ProjectTrackerController.getRecords';
import jsAutoTable from '@salesforce/resourceUrl/jsPdfAutoTable';
import jsPdfUmd from '@salesforce/resourceUrl/jsPdfUmd';
import { loadScript } from 'lightning/platformResourceLoader';
import getFavTasks from '@salesforce/apex/ProjectTrackerController.getFavTasks';



export default class TaskManager extends LightningElement {
  @track isModalOpen = false;
  @track projectOptions = [];
  @track taskOptions = [];
  @track userOptions = [];
  @track selectedProject;
  @track selectedTask;
  @track newTask = "";
  @track logDate;
  @track selectedUser;
  @track startTime; 
  @track endTime;   
  @track description = "";
  @track startDate;
  @track endDate;
  data = [];
//   favTasks;    
//   error;

//   col = [
//     { label: 'FavTask Name', fieldName: 'Name' },
//     { label: 'Task Name', fieldName: 'TaskName__r.Name' },
//     { label: 'Created By', fieldName: 'User__r.Name' }
// ];

@track favTasks = []; // Holds the fetched records
@track col = [
    { label: 'Project', fieldName: 'Project__r.Name', editable: false },
    { label: 'Task Name', fieldName: 'TaskName__r.Name', editable: false },
    { label: 'Date', type: 'date', editable: true },
    { label: 'Start Time', type: 'Time', editable: true },
    { label: 'End Time', type: 'Time', editable: true },
    { label: 'Description', fieldName: 'Description__c', editable: true }
];
@track draftValues = [];


  @wire(getFavTasks)
  wiredFavTasks({ error, data }) {
      if (data) {
        console.log('Wire service data:', data);
          this.favTasks = data;
          console.log('the fav task is ', this.favTasks);
          
          this.error = undefined;
      } else if (error) {
          this.error = error;
          this.favTasks = undefined;
      }
  }

  connectedCallback() {
    this.fetchData();  
}
  
  handleStartDateChange(event) {
    this.startDate = event.target.value;
  }
  
  handleEndDateChange(event) {
    this.endDate = event.target.value;
  }

  jsPDFInitialized = false;
  jsPDFAutoTableInitialized = false;

  renderedCallback(){
    if (!this.jsPdfInitialized) {
        this.jsPdfInitialized = true;
        loadScript(this, jsPdfUmd)
            .then(() => {
                console.log('jsPDF library loaded successfully');
                return loadScript(this, jsAutoTable);
            })
            .then(() => {
                console.log('autoTable plugin loaded successfully');
                this.jsPdfAutoTableInitialized = true;
            })
            .catch((error) => {
                console.error('Error loading jsPDF or autoTable:', error);
            });
    }
}

    //-------------------- Create the Data Table ------------------------------------>
   @track columns = [
      { label: 'Project Name', fieldName: 'projectName__c', type: 'text' },
      { label: 'Task Name', fieldName: 'TaskList__c', type: 'text' },
      { label: 'Date', fieldName: 'Date__c', type: 'date' },
      { label: 'Start Time', fieldName: 'From_Time__c', type: 'date',  typeAttributes:{
        hour: "2-digit",
        minute: "2-digit",
        timeZone: 'Asia/Kolkata'
    }},
      { label: 'End Time', fieldName: 'To_Time__c', type: 'date', typeAttributes:{
        hour: "2-digit",
        minute: "2-digit",
        timeZone: 'Asia/Kolkata'
    }},
      { label: 'Description', fieldName: 'Description__c', type: 'text' }
    ];





  fetchData() {
    getRecords({ startDate: this.startDate, endDate: this.endDate })
        .then(result => {
            this.data = result;
            this.error = undefined;
        })
        .catch(err => {
            this.error = err;
            this.data = undefined;
        });
}

  
  @wire(getProjects)
  wiredProjects({ error, data }) {
    if (data) {
      this.projectOptions = data.map((project) => ({
        label: project.Name,
        value: project.Id
      }));
    } else if (error) {
      console.error(error);
    }
  }
  


  handleProjectChange(event) {
    this.selectedProject = event.detail.value;
    this.resetFields();
    this.fetchTasks();
  }

  resetFields() {
    this.selectedTask = null;
    this.newTask = "";
    this.logDate = undefined;
    this.selectedUser = undefined;
    this.startTime = undefined;
    this.endTime = undefined;
    this.description = "";
    
  }

  fetchTasks() {
    getTasksByProject({ projectId: this.selectedProject })
      .then((result) => {
        this.taskOptions = result.map((task) => ({
          label: task.Name,
          value: task.Id
        }));
      })
      .catch((error) => {
        console.error(error);
      });
  }
  

  handleTaskChange(event) {
    this.selectedTask = event.detail.value;
  }

  handleNewTaskChange(event) {
    this.newTask = event.detail.value;
  }

  handleDateChange(event) {
    this.logDate = event.detail.value;
  }

  handleUserChange(event) {
    this.selectedUser = event.detail.value;
  }

  handleStartTimeChange(event) {
    this.startTime = event.detail.value; 
    console.log(this.startTime)
  }

  handleEndTimeChange(event) {
    this.endTime = event.detail.value; 
    console.log(this.endTime);
  }

  handleDescriptionChange(event) {
    this.description = event.detail.value;
  }

  saveTimeLog(){
    this.createNewTask();
  }

  createNewTask() {

    console.log('start time :', this.startTime);
    console.log('end time : ', this.endTime);
    
    createTimeEntry({ 
      taskId: this.selectedTask,
      dates: this.logDate, 
      fromTime: this.startTime,
      toTime: this.endTime,
      description: this.description
    })
      .then((newTaskId) => {
        console.log("New task created:", newTaskId);
        this.saveEntry(newTaskId); 
      })
      .catch((error) => {
        console.error("Error creating task:", error);
      });
   }

  openModal() {
    this.isModalOpen = true;
  }

  closeModal() {
    this.isModalOpen = false;
  }

  downloadPdf(){
    console.log('inside generateDataInPdf2');
    if (this.jsPdfInitialized && this.jsPdfAutoTableInitialized) {
        try {
            const {jsPDF} = window.jspdf;

    const doc = new jsPDF();
    if(this.data.length === 0) {
        this.showToast('No Data', 'There is no data available for PDF generation.', 'info');
        return;
    }

    
    doc.setFontSize(18);
    doc.text("Task Report", 20, 20);
    doc.setFontSize(12);
    
   
    const headers = ['Project Name', 'Task Name', 'Date', ' StartTime', 'EndTime', 'Description'];
    const rows = this.data.map(task => [
        task.projectName__c,
        task.TaskList__c,
        task.Date__c,
        task.From_Time__c,
        task.To_Time__c,
        task.Description__c
    ]);
    doc.autoTable({
        head: [headers],
        body: rows,
        startY: 30, 
    });
   
    doc.save('Task_Report.pdf');
    
}catch (error) {
        console.log('Error in generating PDF', JSON.stringify(error));
    }
} else {
    console.error('jsPDF library is not loaded');
}
}
}