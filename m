From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 07/17] cgroup: Prevent kill_css() from being
 called more than once
Date: Wed, 17 May 2017 15:23:57 -0400
Message-ID: <20170517192357.GC942@htj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-8-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3s+xZUzISTlfFZ5e63T0VXaDu/noxMW8Vv480St2His=;
        b=XrUiKQGzV7EIUtduhEezbdaEI4lUIVMKAdsUrnaYo7RV3+z00E/1saRAi9McpBm9Mt
         r+mDcNpI8ABTCEBj34Jbn1N5jDv3AC7MVMNG+k0NsJavhnBAX2qyS5yYTmKMxaNuPHzY
         yKHuUtYh1ariCHIkPi2O4kE4OrbmSPgsGZyjX/7OQ+87aTLpRx2SZbpMBB9K8r2MlP+i
         PfTbm221/WeyeXLuznHMcydB5FNYfOB3A2yWKhewt0IbTyATQD7R8Huo4yqJyD0JnZQd
         lPG1ZcI5LSE98WCBf89mT60gH/6dcJ6zaOLPQs9/8teQIX70XnvkmTMuJ84GzsCArgu+
         2EyA==
Content-Disposition: inline
In-Reply-To: <1494855256-12558-8-git-send-email-longman@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello,

On Mon, May 15, 2017 at 09:34:06AM -0400, Waiman Long wrote:
> The kill_css() function may be called more than once under the condition
> that the css was killed but not physically removed yet followed by the
> removal of the cgroup that is hosting the css. This patch prevents any
> harmm from being done when that happens.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

So, this is a bug fix which isn't really related to this patchset.
I'm applying it to cgroup/for-4.12-fixes w/ stable cc'd.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
