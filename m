From: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: don't show pid list on tasks/procs in ascending
 order
Date: Wed, 16 Jan 2013 09:50:35 +0800
Message-ID: <50F6076B.8080704@oracle.com>
References: <50F4E902.20202@oracle.com> <20130115062507.GA21358@sergelap> <50F4F76D.2050409@oracle.com> <20130115063412.GA25338@sergelap> <50F4FD99.7070406@oracle.com> <20130115140811.GA4082@sergelap> <20130115154332.GA2598@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130115154332.GA2598-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hi Serge and Tejun,
On 01/15/2013 11:43 PM, Tejun Heo wrote:
> Hello, guys.
> 
> On Tue, Jan 15, 2013 at 08:08:11AM -0600, Serge Hallyn wrote:
>>> I did this for two reasons, one is for the documents, another is per
>>> Cgroup TODO list from Tejun -- https://lkml.org/lkml/2012/9/13/542
>>>
>>> . Misc issues
>>>
>>>   * Sort & unique when listing tasks.  Even the documentation says it
>>>     doesn't happen but we have a good hunk of code doing it in
>>>     cgroup.c.  I'm gonna rip it out at some point.  Again, if you
>>>     don't like it, scream.
>>
>> Yeah, I figured, and since he also wants to move to a place where
>> cgroups are always manipulated using a library, not by hand, it
>> would make sense to get rid of the overhead there.  I just don't
>> really like either one of those :)  And in the list of things to
>> clean up in cgroups, this seems like one that can wait.
> 
> I want it gone but last time I pinged there were some people depending
> on it, so I don't think I can.  I think we'll have to put it on ice
> for now at least.  :(
Thanks both of you for the response :)  So I'll put it aside for now.

Regards,
-Jeff
