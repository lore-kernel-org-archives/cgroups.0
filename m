From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH for-4.20-fixes] cgroup: fix CSS_TASK_ITER_PROCS
Date: Tue, 20 Nov 2018 08:13:19 -0800
Message-ID: <20181120161319.GR2509588@devbig004.ftw2.facebook.com>
References: <fdb057a2-342a-d49e-587a-f1ca8680033e@gmail.com>
 <20181108201515.GC2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bgwKqPKTuNIZc8ZNsu7oVmFBZQ8IygAJo53SBFGFiIQ=;
        b=V1bA6YEeXrAtNVoYUUFf0jskgCq4F6fh+L1tUr4yzb8+4XauJAgjqEJT4vZI8S7ryQ
         g7yt1a3lwu4fXWSLPSLAO7F/D9UgZkLc9uVpsqIi+bszk5j0RQlf4j4oTC874itO9Lvc
         4fxRpShIc5ARo8KqCeVpAQY5Cx/MKFkuAeEXM3hGPRGI+pa1kZ0adZq+4RLqhKTU9SAO
         JkjtMmTV1v5movdnpcR7sg4IYmloHCavOT/Hmit++RUJfNucmgbnbNyEF4R5tpe4sKQ+
         ufzT0OaMpBZumOBDp6Q52NQ2isscfdZb0uhux60HLPaVJkUlAVyfyBx8Ty1te+A094jm
         0TCQ==
Content-Disposition: inline
In-Reply-To: <20181108201515.GC2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, kernel-team@fb.com

On Thu, Nov 08, 2018 at 12:15:15PM -0800, Tejun Heo wrote:
> CSS_TASK_ITER_PROCS implements process-only iteration by making
> css_task_iter_advance() skip tasks which aren't threadgroup leaders;
> however, when an iteration is started css_task_iter_start() calls the
> inner helper function css_task_iter_advance_css_set() instead of
> css_task_iter_advance().  As the helper doesn't have the skip logic,
> when the first task to visit is a non-leader thread, it doesn't get
> skipped correctly as shown in the following example.

Applied to cgroup/for-4.20-fixes.

Thanks.

-- 
tejun
