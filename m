From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: Fix deadlock in cpu hotplug path
Date: Tue, 19 Dec 2017 05:39:58 -0800
Message-ID: <20171219133958.GM3919388@devbig577.frc2.facebook.com>
References: <b50d7b64-121f-9a4c-5269-aec9a73787ba@codeaurora.org>
 <1513668417-26785-1-git-send-email-prsood@codeaurora.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=unERHvaKdAwB0WtFjlFkfuQ9GRYaS3gEW+xWCmyRqo0=;
        b=AosYbDyGXGRRU8p9CH0vtQVLiQw7D4yiLVC8Jg0wyKHIV8VamRAhNA5mINoXmUqo/3
         NRk6PRCnxFsd/m1+bdneN6SrV6SvLeeySWQWjDWUhCcf+5LhsE6uUfSB5LHSjYguFymX
         k/7dzGXdgiVvGSe9znnLOtbncvMV16KNUAGc6DuSYI9gvY+Mb5oHoeDRhmJyl7cU4vaV
         3jMkaek3AWbRes53nTaYrmBMhdkmr0MLGoNCotubEiOpNm18fdK73JvwVkPqvBm+rYv3
         aKMt4AreNA+Ok5A8sU41vuQIwDpHEfC80ejMv+sNv+r3vG81debRa1lzQbQyxlgmIUuJ
         3P7Q==
Content-Disposition: inline
In-Reply-To: <1513668417-26785-1-git-send-email-prsood@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood@codeaurora.org>
Cc: peterz@infradead.org, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

On Tue, Dec 19, 2017 at 12:56:57PM +0530, Prateek Sood wrote:
> Deadlock during cgroup migration from cpu hotplug path when a task T is
> being moved from source to destination cgroup.
...
> Task T inserted a work item in the worklist of cpu0 low priority
> worker pool. It is waiting for expedited grace period work item
> to execute. This work item will only be executed once kworker/0:0
> complete execution of cpuset_hotplug_workfn().
> 
> kworker/0:0 ==> Task T ==>kworker/0:0
> 
> In case of PF_EXITING task being migrated from source to destination
> cgroup, migrate next available task in source cgroup.
> 
> Change-Id: I8874fb04479c136cae4dabd5c168c7749df66664
> Signed-off-by: Prateek Sood <prsood@codeaurora.org>

Applied to cgroup/for-4.15-fixes.

Thanks a lot, Prateek.

-- 
tejun
