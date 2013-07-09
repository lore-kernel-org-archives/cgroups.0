From: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Tue, 09 Jul 2013 17:15:14 +0400
Message-ID: <51DC0CE2.2050906@openvz.org>
References: <20130708100046.14417.12932.stgit@zurg> <20130708170047.GA18600@mtj.dyndns.org> <20130708175201.GB9094@redhat.com> <20130708175607.GB18600@mtj.dyndns.org> <51DBC99F.4030301@openvz.org> <20130709125734.GA2478@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=BiYsMIoDns9k/DMiN0YETmhEU7rIp35HDI85K3oc7BQ=;
        b=awBQKEemVeNlc95vpQhekSUPmsxOSNjx8J1QqaCm8yYZM4b2npWxtXZYJaymbZVTWF
         Cbn5fMJDa9l2hPCrpeFt47RTRmdBfx0BQGR1azh8luuvPDvIegRW6IJuPDHMrI725saF
         wTLBOtvgKPC8mp83CipI2m2YxzEY85x0LdVR2pE+IxrjUGKOMiwprNeji4t9bK/3k0Ck
         cpo6TyIV3W6iWnTfKa//z1On9s+LSu/DJfumNgHiNZu4F5uQKSqSe4tjGrMXiZn8N467
         n+lQm1dqyKyEoBpyRHnLSmmegnycIiBRHEctdlaBTjQ4ljjBnr95OdNqmcgzuZK2T1vZ
         4BBg==
In-Reply-To: <20130709125734.GA2478-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Tejun Heo wrote:
> Hello,
>
> On Tue, Jul 09, 2013 at 12:28:15PM +0400, Konstantin Khlebnikov wrote:
>> Yep, blkio has plenty problems and flaws and I don't get how it's related
>> to vfs layer, dirty set control and non-disk or network backed filesystems.
>> Any problem can be fixed by introducing new abstract layer, except too many
>> abstraction levels. Cgroup is pluggable subsystem, blkio has it's own plugins
>> and it's build on top of io scheduler plugin. All this stuff always have worked
>
> What does that have to do with anything?
>
>> with block devices. Now you suggest to handle all filesystems in this stack.
>> I think binding them to unrealated cgroup is rough leveling violation.
>
> How is blkio unrelated to filesystems mounted on block devices?
> You're suggesting a duplicate solution which can't be complete.

blkio controls block devices. not filesystems or superblocks or bdi or pagecache.
It's all about block layer and nothing more. Am I right?

So, you want to link some completely unrelated subsystems like NFS into the block layer?

>
>> NFS cannot be controlled only by network throttlers because we
>> cannot slow down writeback process when it happens, we must slow
>> down tasks who generates dirty memory.
>
> That's exactly the same problem why blkio doesn't work for async IOs
> right now, so if you're interested in the area, please contribute to
> fixing that problem.
>
>> Plus it's close to impossible to separate several workloads if they
>> share one NFS sb.
>
> Again, the same problem with blkio.  We need separate pressure
> channels on bdi for each cgroup.
>
> Thanks.
>
