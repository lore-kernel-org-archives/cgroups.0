From: "Joshi, Venu" <Venu.Joshi-Iz5qeGvAONRWk0Htik3J/w@public.gmane.org>
Subject: RE: cgroup kernel API question
Date: Thu, 4 Aug 2016 18:59:51 +0000
Message-ID: <CF4362088901AA4FAA2113B97CB826F0197B304A@SUSHDC8002.TD.TERADATA.COM>
References: <CF4362088901AA4FAA2113B97CB826F0197B26CB@SUSHDC8002.TD.TERADATA.COM>
 <20160804143446.GA4748@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Resend with the right cc email address.

-----Original Message-----
From: Joshi, Venu 
Sent: Thursday, August 04, 2016 10:59 AM
To: 'tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org'
Cc: 'groups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'
Subject: RE: cgroup kernel API question

Thanks.

Our database server creates a sub directory (say TeradataCgroup) under the root cgroup and manages all processes/tasks and ensures proper synchronization across multiple accessors.  These processes/tasks may create further sub-directories under /root-cgroup/TeradataCgroup/ with different cpu.share values.   The tasks constantly migrate to different cgroups at different hierarchical levels based on the priority of the user SQL/query/request.  All this happens when the tasks have trapped into the kernel mode via a syscall. 

Our Teradata Database server is a highly parallel application and uses kernel mode synchronization APIs (spinlocks etc.,) via a kernel mode driver extension to achieve synchronization.   Hence we mostly try to use Kernel API for key operations.   In our application, cgroup operations are never done in userland to avoid the problem you mentioned below (severely confusing userland that is trying to use the cgroups too).

Thanks
Joshi


-----Original Message-----
From: Tejun Heo [mailto:htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On Behalf Of tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Sent: Thursday, August 04, 2016 7:35 AM
To: Joshi, Venu
Subject: Re: cgroup kernel API question

Hello, Joshi.

On Wed, Aug 03, 2016 at 09:59:14PM +0000, Joshi, Venu wrote:
> I've seen the extensive work that you've done with cgroups (v1 and v2).
> 
> I work at Teradata and our database server uses cgroups pretty 
> extensively.  We have a kernel driver that directly calls sched/cgroup 
> API to create cgroups , assign tasks to these groups, set shares for 
> these cgroups.  However, there is a limited support for Kernel drivers 
> to directly use cgroups (and we have to hack around these unexported 
> functions to call them in our kernel driver).
> 
> Do you know if there are any requests to provide an interface to work 
> with cgroups in a kernel driver.  There are multiple options available 
> for user mode applications to use the cgroups (system, libcgroup etc.)

The inherent problem there is that cgroup itself doesn't provide any synchronization mechanisms among multiple accessors and most operations are multi-step.  So, if you add in-kernel cgroup operations, that can severely confuse userland which is trying to use cgroup.  I can't tell much without knowing details of your usage, but it's likely that there is a better of handling the issue than directly initiating cgroup operations from kernel side.  Also, please cc cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org in future messages.

Thanks!

--
tejun
