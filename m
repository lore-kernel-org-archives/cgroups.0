From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v5 2/2] writeback, cgroup: release dying cgwbs by
 switching attached inodes
Date: Thu, 27 May 2021 09:29:56 -0700
Message-ID: <YK/JBDxsZQwC0q8J@carbon.DHCP.thefacebook.com>
References: <20210526222557.3118114-1-guro@fb.com>
 <20210527032459.2306-1-hdanton@sina.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=R8ZMG4jJXCPWRao7W7bJfPCzcxw625gj7FlXrxTH8W8=;
 b=g6DnJH9ojrQ/UkBEGAIhVxs609mzImCV3Y808GFAcYdRkFMeGUdEPEK/a28BiQkBG2ek
 AKAa1Uk0bLQquY2j/NvsnrhblreLR7BhJO4JaQ3cRcGK8XRuN/bftdHEu4BxdjthQoSU
 E8VC7zVo9mfAPNoX1j1ZL6m2CAbExzrbd2M= 
Content-Disposition: inline
In-Reply-To: <20210527032459.2306-1-hdanton-k+cT0dCbe1g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 27, 2021 at 11:24:59AM +0800, Hillf Danton wrote:
> On Wed, 26 May 2021 15:25:57 -0700 Roman Gushchin wrote:
> >+
> >+	if (!list_empty(&offline_cgwbs))
> >+		schedule_work(&cleanup_offline_cgwbs_work);
> >+
> 
> Good work overall.

Thanks!

> 
> Nit, given cond_resched_lock() in cleanup_offline_wb(), what you need instead
> is
> 	queue_work(system_unbound_wq, &cleanup_offline_cgwbs_work);

Neat, will do in the next version.

Thanks!
