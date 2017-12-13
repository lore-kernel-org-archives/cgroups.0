From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Wed, 13 Dec 2017 07:40:41 -0800
Message-ID: <20171213154041.GP3919388@devbig577.frc2.facebook.com>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <4e63b5e9-1696-910f-16ac-4d4d7eb98725@codeaurora.org>
 <40968aea-cd73-5ce4-d559-962d91e315c5@codeaurora.org>
 <20171211153258.GI2421075@devbig577.frc2.facebook.com>
 <c54d904e-13bc-8e2b-c9c1-8bf9cb8a33a3@codeaurora.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pa7j0kNwndei7PLawlT6bmT+/hIaKFWOnohm2o0JPYc=;
        b=S3gQk2FPPR0DY43RxmqF7OwizgYBQINPb4LyNNmzgsWWl2j8l16/DlI5Gecsnp13Ja
         w4XrZDpeMaLrqon0J1+/f+m3ChPScsRhgs8mv8tQh8uG6XwHFQwlldsd7K9alQaUOkOJ
         iGEiPEd2TGQZJGrvb0Fxla9ih7MVA+2/cw2gq64z4wgWZifMmy6ALSIuVQssQup1piUo
         jymWlTY6JEFQs0r46+7ZAakBTDl/FdwfB/hpu+qHl1fJGsDVrJRrlNqV2jrGpNGZqQ/Q
         uDniuaos1SxXQ3SdbANYyM6Q9svVVKmEqtCpv8F8TtPMyiqgXwraLEI3kiryXJjb+J9S
         1pBg==
Content-Disposition: inline
In-Reply-To: <c54d904e-13bc-8e2b-c9c1-8bf9cb8a33a3@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood@codeaurora.org>
Cc: Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

Hello, Prateek.

On Wed, Dec 13, 2017 at 07:58:24PM +0530, Prateek Sood wrote:
> Did you mean something like below. If not then could you
> please share a patch for this problem in
> cgroup_transfer_tasks().

Oh we surely can add a new iterator but we can just count in
cgroup_transfer_tasks() too, right?

Thanks.

-- 
tejun
