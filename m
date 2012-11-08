From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: implement proper
 hierarchy support
Date: Thu, 8 Nov 2012 10:01:41 -0800
Message-ID: <20121108180141.GB9672@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-pm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9rLIn2K9pWrE6sBQnhjy/C/AU29pco/2psm5exEMZ3U=;
        b=yjtcu5BWPkHhK/+lWOfIqijDRXdstMJ2u5Ax+Dvf1Yh7k5hc4UXBA1P5yDWdeKVMKO
         67V7fbnBGPTeOgsEi7AETKhEElQMMj9SuNb3HgPsjypy2ZQ86kG/788ZmYLGfDIXH4vy
         Z+jaOWXzOM1alDe5VcdTeD2PdHABQi6iMcbbpzl65JieH5sNY3nxfFyS8SvSd9xepkN6
         9Bnft5VT+fNBYrwQmYX0kxGd9faUw7QVPgkRfGF6aOgQcthBKdv8vwxz5Zeo3p9JS6ew
         uaACM4Mn6yliEepdfZzjrFloSxzgoY9cj6+Oue75HRRNi6esIlyQdVHtWBOAOV+oy51G
         6gxQ==
Content-Disposition: inline
In-Reply-To: <1351931915-1701-1-git-send-email-tj@kernel.org>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, fweisbec@gmail.com

On Sat, Nov 03, 2012 at 01:38:26AM -0700, Tejun Heo wrote:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup_freezer-hierarchy

Updated patches posted as replies to the original patches and the
above git branch updated with the updated patches.  As all the updates
are minor, I won't re-post the whole series.

Thanks.

-- 
tejun
