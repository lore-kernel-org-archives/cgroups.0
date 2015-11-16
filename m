From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-4.4-fixes] cgroup: fix cftype->file_offset
 handling
Date: Mon, 16 Nov 2015 10:59:11 -0500
Message-ID: <20151116155911.GD18894@mtj.duckdns.org>
References: <20151105051224.GA4914@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RGu2VlyW91fznEkeXQsoh16lM+T/v1JVmQWgov2vI7g=;
        b=z5UD7hzGrmsjsK5PtBUkHML48ipId5nCQ0o0Kgtja4urQYOpZFbaDBqqvAXv+Hy4gJ
         5i8aBsm/vufoI1+FOSjt3yL+2FS/7ej8vIlyPWFm81JhhvHpdtKReUGfUGnjLqMMvjqZ
         xuxYt95s4EC28rGqVu86+TAGjIdieKFtR2w7fPmm/NmLjC1xBgkwBr32cSlmDfPIbnur
         aRk2TanKMlYZlVttCnIt7i7Ib2I6fcRGi5cA4jj7MbxRjZ7fgs27SzLS+uyneF/CsY8o
         tgDiibKSPm8eWWc3SG+UMdXbRtdb9MFb/Ue+xE+CchLhEW6eWHpnnQA6f6SulSsCaI9F
         e3zQ==
Content-Disposition: inline
In-Reply-To: <20151105051224.GA4914@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, James Sedgwick <jsedgwick@fb.com>, kernel-team@fb.com

On Thu, Nov 05, 2015 at 12:12:24AM -0500, Tejun Heo wrote:
> 6f60eade2433 ("cgroup: generalize obtaining the handles of and
> notifying cgroup files") introduced cftype->file_offset so that the
> handles for per-css file instances can be recorded.  These handles
> then can be used, for example, to generate file modified
> notifications.
> 
> Unfortunately, it made the wrong assumption that files are created
> once for a given css and removed on its destruction.  Due to the
> dependencies among subsystems, a css may be hidden from userland and
> then later shown again.  This is implemented by removing and
> re-creating the affected files, so the associated kernfs_node for a
> given cgroup file may change over time.  This incorrect assumption led
> to the corruption of css->files lists.
> 
> Reimplement cftype->file_offset handling so that cgroup_file->kn is
> protected by a lock and updated as files are created and destroyed.
> This also makes keeping them on per-cgroup list unnecessary.

Applied to cgroup/for-4.4-fixes.

-- 
tejun
