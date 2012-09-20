From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup, sched: let cpu serve the same files as
 cpuacct
Date: Thu, 20 Sep 2012 11:00:49 -0700
Message-ID: <20120920180049.GG28934@google.com>
References: <1348094625-4471-1-git-send-email-tj@kernel.org>
 <1348094625-4471-3-git-send-email-tj@kernel.org>
 <505ACE36.80603@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zkLrtGNNbRyVBvcPjSuJVHGKEr7dKleh0Ve+DYKY7IU=;
        b=EcStSXJEq9+9xqD/Vk+OkWanzQxnXi/2JQ75fZHaQRq+ubsFYD/9i2/fWJj3DmVUK2
         PZVyimdInbMj+UCcZWfwcQLyuOevn1g5r00Wa7M7x7rDnB9Jcih1AtP4crxhx77T2QWe
         FVszmpl/YbI+aGWE1qenl/lx5/U6xiMXHvbTP+L8ACAVwFxYgO6XxpXLI4vIGhkoPLhI
         CJuvW+/CqT8G5f/TrEPu/1VoV2v6oSLFPBhBdRj1LQLDN1V8pCXFtRJqaD/nCvsvyAcM
         t13kThRUgCNa2ODF4CtP17Ac/ITM/YVeaHET6BMF/Kv73S5gGxZjUjYrtm8JLgQzCTBN
         QHwQ==
Content-Disposition: inline
In-Reply-To: <505ACE36.80603-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org, mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org, davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hell, Glauber.

On Thu, Sep 20, 2012 at 12:05:10PM +0400, Glauber Costa wrote:
> The whole point of this merge is that this is not needed.

Yeah, the whole point of this series is enabling that and other
optimizations.

> This information is already available from exec_clock for fair tasks.
> for rt tasks, we have no exec clock, but do have a hierarchy walk a bit
> below the current cpuacct charge, that can be used for that purpose.

Yeah yeah, sure, now you can build that on top of this patchset
without worrying about cpuacct, which can also, hopefully, be removed
fairly soon.

Thanks.

-- 
tejun
