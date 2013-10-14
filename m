From: Hong zhi guo <honkiko@gmail.com>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Date: Mon, 14 Oct 2013 21:47:23 +0800
Message-ID: <CAA7+ByWpRH2KSDBZ1ZRhvSSmfG2LHv+WO7F49oWLFpOTsj9cUA@mail.gmail.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
	<1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
	<20131014133620.GF4722@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=U2O9UH03Gh2nqmhDjIH2N6N1AiTKEUitkZu6gLkKSAU=;
        b=JZr6avsF4C82ImMQtIsuwjbF3RxSdx/IP2HQdDv6PMzGx3Kn4jUCxnlgXZ2Pj0PB/J
         w3kp3CagORyhrYedFe4K8t04+hK5yzBKebvydib7iP2zIjJNItLZWUttWaCqgjXe+ofH
         SUuejc4yR8sw5dabwXgZK/Z+sDJuRMBWyDeeaWCZxfo2nh1ehB2lUKp7LNzp+BKowOEc
         52iNv5MxKvyQbTX2ZNwc9cd1luuieLOextu9euZj3amTcSsaLoE3puhkhUSLlogBnQN5
         VQNK2cvd1wVtk5DZqXZoklvq/kLayitsE0UeMYZiX/aBcwYR6W02cQ6rc4FY//sxLsjH
         Htkg==
In-Reply-To: <20131014133620.GF4722@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, vgoyal@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>

Hi, Tejun,

I've not tested hierarchical setup yet. I'll do it tomorrow.
BTW, what kind of setup do you expect? Is 2 levels of hierarchical enough?

Zhiguo

On Mon, Oct 14, 2013 at 9:36 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> Yes, this definitely is the direction we wanna take it.  I'll wait for
> Vivek to chime in but have you also tested hierarchical setup?
>
> Thanks.
>
> --
> tejun



-- 
best regards
Hong Zhiguo
