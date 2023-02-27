From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: Add 'malloc' failures checks in test_memcontrol
Date: Mon, 27 Feb 2023 17:00:01 +0000
Message-ID: <20230227170001.ka5eyfscvdypc2oc@google.com>
References: <20230226131634.34366-1-ivan.orlov0322@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=75A0gEwys1mFY3sJ5wHScJ9ljDVthV3+ryRrHEENcQo=;
        b=cLtWhUG9qsA4Sg24ae9fYUU4+Jizp49jqXT9Sfy+9fByadRsDkot02jjzzg5b2L5Xs
         4p31MmnUIDIGwI0i/YSZGLRpX+ovsl39jJqI4PvJvxCbjeEQ+Qgawa2WEoiPTofV4BDa
         RlEha9mid0gYgb6ZrswEsykY7taZ9zgYENPxcCJgUDJ5aCXp4DYkULEQrtgAF7HwaDWD
         47tC1GMc9jX+XOMQrLfWidvs+Ppgw0lAJ2qMjRHZWhSqHcDOV9Sp1X96Cqel9TG8FKCt
         XUDU2HOvl03Pnq2Ioq1hngvzmArdOS/tf8YuPsxB5FNETBKRe5UoIcOan7vC6M/xITna
         zm9w==
In-Reply-To: <20230226131634.34366-1-ivan.orlov0322-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Ivan Orlov <ivan.orlov0322-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org

On Sun, Feb 26, 2023 at 04:16:33PM +0300, Ivan Orlov wrote:
> There are several 'malloc' calls in test_memcontrol, which can be
> unsuccessful. This patch will add 'malloc' failures checking to
> give more details about test's fail reasons and avoid possible
> undefined behavior during the future null dereference (like the
> one in alloc_anon_50M_check_swap function).
> 
> Signed-off-by: Ivan Orlov <ivan.orlov0322-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
