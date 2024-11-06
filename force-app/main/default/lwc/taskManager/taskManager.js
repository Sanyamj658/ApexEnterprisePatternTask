
import { LightningElement, track, wire } from "lwc";
import getProjects from "@salesforce/apex/ProjectTrackerController.getProjects";
import getTasksByProject from "@salesforce/apex/ProjectTrackerController.getTasksByProject";
import createTimeEntry from "@salesforce/apex/ProjectTrackerController.createTimeEntry";
import getUsers from "@salesforce/apex/ProjectTrackerController.getUsers";
import getRecords from '@salesforce/apex/ProjectTrackerController.getRecords';
//import jsPDF from 'c/jspdf';



export default class taskManager extends LightningElement {
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
  
  handleStartDateChange(event) {
    this.startDate = event.target.value;
  }
  
  handleEndDateChange(event) {
    this.endDate = event.target.value;
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

  @wire(getRecords,{startDate : '$startDate', endDate :  '$endDate'}) account({error,data})
  {
      if(data)
      {
          this.data = data;

      }
      else if(error){
          this.error = error;
      }
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

  @wire(getUsers)
  wiredUsers({ error, data }) {
    if (data) {
      this.userOptions = data.map((user) => ({
        label: user.Name,
        value: user.Id
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

  downloadPdf() {
    if (this.startDate && this.endDate) {
        const startDateParam = encodeURIComponent(this.startDate);
        const endDateParam = encodeURIComponent(this.endDate);
        window.download(strFile, "sample.pdf", "application/pdf");
        //window.open(`/apex/YourPdfPageName?startDate=${startDateParam}&endDate=${endDateParam}`, '_blank');
    } else {
        console.warn('Please select both start and end dates.');
    }
}

}
