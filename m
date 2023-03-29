From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/4] cgroup/cpuset: Fix partition root's cpuset.cpus
 update bug
Date: Wed, 29 Mar 2023 08:37:48 -1000
Message-ID: <ZCSFfMeKRNERIBu6@slm.duckdns.org>
References: <20230317151508.1225282-1-longman@redhat.com>
 <20230317151508.1225282-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680115070;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uzLVbqgNBGN+xgE2Mcn5+0Hj/oLlv/psLQjcDCgpQr8=;
        b=kI+OaINANyKsiK+EWK5+yOqs4+8ljyMo3j6zqxxM9CNCGiuVso5j4vGdrojGjNs0yY
         0bWcLXqZlHNd5KEaFaq42TZPydl8CX+VZaczevLdxTDrOS+bRtk1uU3ldZcJ5GOoafYt
         EfJ3UBHdLiykj7ApCxebT76Fae/+kGPt8b03FuNjlP2cQ+kDqjpxVP30APPgIeDDwUAK
         JUwZpewbV42SJXpI7IZJO7GrUs0qCUeGrPItHGrUZVp9xHlP0F0DVVVfimp2uH4A+9XJ
         cvYw6G7wBHW7jwMokNIetOkS2+pSnTcBC41bJiINKqOlqkpoX06t8GHNFjgmTOmqgrdj
         y52A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230317151508.1225282-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Fri, Mar 17, 2023 at 11:15:05AM -0400, Waiman Long wrote:
> It was found that commit 7a2127e66a00 ("cpuset: Call
> set_cpus_allowed_ptr() with appropriate mask for task") introduced a bug
> that corrupted "cpuset.cpus" of a partition root when it was updated.
> 
> It is because the tmp->new_cpus field of the passed tmp parameter
> of update_parent_subparts_cpumask() should not be used at all as
> it contains important cpumask data that should not be overwritten.
> Fix it by using tmp->addmask instead.
> 
> Also update update_cpumask() to make sure that trialcs->cpu_allowed
> will not be corrupted until it is no longer needed.
> 
> Fixes: 7a2127e66a00 ("cpuset: Call set_cpus_allowed_ptr() with appropriate mask for task")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.3-fixes w/ stable cc'd.

Thanks.

-- 
tejun
