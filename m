From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 06/17] cgroup: Fix reference counting bug in
 cgroup_procs_write()
Date: Wed, 17 May 2017 15:20:19 -0400
Message-ID: <20170517192019.GB942@htj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-7-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cOSUM7C3I81ygIB3+HmNcXQzttR8YvIlTqLEsE1xXcE=;
        b=Iq7PzQXudXG1SXKHOi4ekhmHSEhRCrYl5TvpEcPCn9aAlJ1oN/iGELqr7kp1opUyoF
         IiyJpEl+QFE4rFK0jE1025kRtWH7rXcSYhNzsVGxCgtJjbdUDB/cXgIakKYej+YsLwC4
         wG7TJyAALMGhpvDe9wpFU2BwJi1RWoKK7xTjFMMWpz78VM6vyALnDlqKlCRgegqeFokj
         8/kzPrCsg23M0Vi8oaBT70ch4dH3YGKPOceX8VHcDVNObTdcamvQaeD6rx0WQSEv8u11
         Q4U1TQwGqkER4LiLXkDKLKU3xhlNJfb613GzH3vbWs8RrAaiI8LCna3IWcdwZFfqIWWD
         tOxg==
Content-Disposition: inline
In-Reply-To: <1494855256-12558-7-git-send-email-longman@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

On Mon, May 15, 2017 at 09:34:05AM -0400, Waiman Long wrote:
> The cgroup_procs_write_start() took a reference to the task structure
> which was not properly released within cgroup_procs_write() and so
> on. So a put_task_struct() call is added to cgroup_procs_write_finish()
> to match the get_task_struct() in cgroup_procs_write_start() to fix
> this reference counting error.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
