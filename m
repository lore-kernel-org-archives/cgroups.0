From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] device_cgroup: fix RCU imbalance in error case
Date: Tue, 19 Mar 2019 10:47:25 -0700
Message-ID: <20190319174725.GA69236@devbig004.ftw2.facebook.com>
References: <20190319013659.86199-1-jannh@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3TV5JSMWzDFmGtM2a9PqyZpbM8Cae0apS79wiWWNBuA=;
        b=Of9nZV6g8OozSHtv9gaoyJHGTNVH7aXpFqRf7RG2ulzzh7pwgQj53Ja9kX4SRoysBf
         WTKUwYdhh2cfDrebplPomarUMEhL9wABj/zt2or1kA+U9nPmOmvu8bTqYnxuZcgNZUmU
         tkP6/jg11wyPjsJxwqSNiWbSz57afpm12rthIEQM5jtGDCutSoQDnwIcSgNiW/mDuErG
         CublhaTz5si8j5tJnDxiB8H4gboyWwZw9o34/V5gWFi4+u58GPYemOmMoJ9Iekhxniya
         i5AQNeWP/Whmt+HztHFXJQdO2K12aJk/BkdI/7D0PdklhRP84DYlAqncJICe247p4L5Y
         yU4w==
Content-Disposition: inline
In-Reply-To: <20190319013659.86199-1-jannh@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jann Horn <jannh@google.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Aristeu Rozanski <aris@redhat.com>, "Serge E . Hallyn" <serge.hallyn@ubuntu.com>, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org

On Tue, Mar 19, 2019 at 02:36:59AM +0100, Jann Horn wrote:
> When dev_exception_add() returns an error (due to a failed memory
> allocation), make sure that we move the RCU preemption count back to where
> it was before we were called. We dropped the RCU read lock inside the loop
> body, so we can't just "break".
> 
> sparse complains about this, too:
> 
> $ make -s C=2 security/device_cgroup.o
> ./include/linux/rcupdate.h:647:9: warning: context imbalance in
> 'propagate_exception' - unexpected unlock
> 
> Fixes: d591fb56618f ("device_cgroup: simplify cgroup tree walk in propagate_exception()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jann Horn <jannh@google.com>

Applied to cgroup/for-5.1-fixes.

Thanks.

-- 
tejun
