From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] cgroup: Add documentation for cgroup namespaces
Date: Tue, 24 Nov 2015 12:16:31 -0500
Message-ID: <20151124171631.GT17033@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-9-git-send-email-serge@hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YkdY0gFIYfuOAWeFIMv1ZiBww7Pc5x+Z1r99G99Y72U=;
        b=w6kaD60CB4sOvsOmWAQE8HZSdLLjsjbYgXMxk3I3kHwuQyneAlxxlZQv+oOMMQ/eNe
         yqxZHsPP2o6K/icnFM/Utcc6AZjrERlHPQTJSWiHL62tUHG28KW00IluItFUrdbU7RFV
         l2ed2W8GL++0SADms44FXgO7wGsRnoq1BqtENZe1PBU+SQ31d0GUhvc0j+lOgs/dhAzB
         kqn11Mv1abpMQRJgh7vFsAunS00aBn0eBoRg2yjdIJ8oNjIXIndj0mXlmccIxK/aogE4
         V4hHfvdD7B4Wcapd9R1XawObLhkhYxvfgOkge40xQMhFvZVtN2CTCiQxD00V+HhIWDEa
         cg3w==
Content-Disposition: inline
In-Reply-To: <1447703505-29672-9-git-send-email-serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Mon, Nov 16, 2015 at 01:51:45PM -0600, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org wrote:
> From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/cgroups/namespace.txt |  142 +++++++++++++++++++++++++++++++++++

Please refresh on top of cgroup/for-4.5 branch.

Thanks.

-- 
tejun
