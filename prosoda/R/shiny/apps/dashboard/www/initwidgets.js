 // This file is part of prosoda.  prosoda is free software: you can
 // redistribute it and/or modify it under the terms of the GNU General Public
 // License as published by the Free Software Foundation, version 2.

 // This program is distributed in the hope that it will be useful, but WITHOUT
 // ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 // FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 // details.

 // You should have received a copy of the GNU General Public License
 // along with this program; if not, write to the Free Software
 // Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 // Copyright 2013 by Siemens AG, Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
 // All Rights Reserved.

//
// Initialize Gridster for adding widgets dynamically
// 
$(function(){ //document ready
 
  Shiny.addCustomMessageHandler("GridsterMessage",
  	function(message) {		
			switch(message.msgname) {
			case 'addWidget': 
				var gridster = $(".gridster ul").gridster().data('gridster');
				Shiny.unbindAll();
				gridster.add_widget( message.html, message. size_x, message.size_y, message.col, message.row );
				Shiny.bindAll();
				break;
			}
		}
	);
});