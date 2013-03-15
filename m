From: Vasily Kulikov <segoon@openwall.com>
Subject: Re: [PATCH 3/4] fs: allow mknod in user namespaces
Date: Fri, 15 Mar 2013 22:03:08 +0400
Message-ID: <20130315180308.GA5526@cachalot>
References: <1363338823-25292-1-git-send-email-glommer@parallels.com>
 <1363338823-25292-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=RIAtnjyTpJpfXHUIGLo0j7QZYDZRMkUFT/z4B8tD4t4=;
        b=Xc/tiCbmNxqL9fMf+C1A2maIeLHCDa+JshdGbQ6yCJdZ3aujUrui/1Cb1In/8SjGjw
         hGQSfSjMQsjdTYM/i61qqmtBOn7UszR7z5VDc4EVc9tFTheIco56sEI7zINlLe6wrzup
         U5g1u+DzYRX/3qizuDtVBzF0VN3toW4nNfqkt9Dv/d5H3z/8UT7jLs+eYcmsy2cnsS7c
         7InyJf1EHiIin+k+5+4DTg3jvn3Y63YqVggc8RfiHFq9eh9KRTR2Fx0j7EkAltYbcV6L
         acA7OSiitIvtNLpD1taEAVQs3lYea/eyMmRVm+rpsWLRehesLch89riR2LUe0IvQzQNZ
         /2Cw==
Content-Disposition: inline
In-Reply-To: <1363338823-25292-4-git-send-email-glommer@parallels.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, Aristeu Rozanski <aris@redhat.com>, mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>

On Fri, Mar 15, 2013 at 13:13 +0400, Glauber Costa wrote:
> Since we have strict control on who access the devices, it should be
> no problem to allow the device to appear.
...
> -	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
> +	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !nsown_capable(CAP_MKNOD))

As now we have several mechanisms for dev nodes usage in containers
(cgroup, per-fs flags, CAP_MKNOD), probably it's better to document
all this stuff in a single document?  Enumerate all possible limits
of device files creation and usage, and describe unobvious ways to
abuse the API to escape from a container (allow loopback device?
allow ext4?  just guessing, didn't investigate myself).  It should
document several safe patterns for common cases and beware of
known-to-be-vulnerable ones.

Thanks,

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
