From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Tue, 9 Jul 2013 05:57:34 -0700
Message-ID: <20130709125734.GA2478@htj.dyndns.org>
References: <20130708100046.14417.12932.stgit@zurg>
 <20130708170047.GA18600@mtj.dyndns.org>
 <20130708175201.GB9094@redhat.com>
 <20130708175607.GB18600@mtj.dyndns.org>
 <51DBC99F.4030301@openvz.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/cHjhmQ3G5uqZ2AwU+sYcCnsmIQ4yiglzjQJH4tsu4Q=;
        b=yG+6FpBRa0GInhtarRXbSkM9tUWMbpuc/iLD4EiPP2gbXsX1kN5MSStImGB0uE3mNG
         eFHKfmbwO0OPaFL7sMJJNJz2M3czSlIuZmJaEMAyG8bSsomV7o7L6Z6VwGUmG36JjgK5
         zkfqXWEaprnF/JC9Ucg4G2XdwpkUfjVj8gccQktkBIDG1qvt5Z1uFLSNDswfr46PXo/j
         TVV3KyAvnkLSIGb57IFHCAofik2C5tOI+Wxs4q2RrVc/OJsb2quEJOUt9gAaUNg4CK+x
         hUzuHfdxRQaWLQYP8pCmHZQDOS8YMvIZ0J9ELUluHxRFMb8AcLIGabR16BVUEj9Kq778
         jSOg==
Content-Disposition: inline
In-Reply-To: <51DBC99F.4030301@openvz.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org, Jens Axboe <axboe@kernel.dk>

Hello,

On Tue, Jul 09, 2013 at 12:28:15PM +0400, Konstantin Khlebnikov wrote:
> Yep, blkio has plenty problems and flaws and I don't get how it's related
> to vfs layer, dirty set control and non-disk or network backed filesystems.
> Any problem can be fixed by introducing new abstract layer, except too many
> abstraction levels. Cgroup is pluggable subsystem, blkio has it's own plugins
> and it's build on top of io scheduler plugin. All this stuff always have worked

What does that have to do with anything?

> with block devices. Now you suggest to handle all filesystems in this stack.
> I think binding them to unrealated cgroup is rough leveling violation.

How is blkio unrelated to filesystems mounted on block devices?
You're suggesting a duplicate solution which can't be complete.

> NFS cannot be controlled only by network throttlers because we
> cannot slow down writeback process when it happens, we must slow
> down tasks who generates dirty memory.

That's exactly the same problem why blkio doesn't work for async IOs
right now, so if you're interested in the area, please contribute to
fixing that problem.

> Plus it's close to impossible to separate several workloads if they
> share one NFS sb.

Again, the same problem with blkio.  We need separate pressure
channels on bdi for each cgroup.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
