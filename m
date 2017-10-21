From: Nick Desaulniers <nick.desaulniers@gmail.com>
Subject: Re: [PATCH] cgroup: reorder flexible array members of struct cgroup_root
Date: Sat, 21 Oct 2017 12:08:42 -0700
Message-ID: <CAH7mPvihpc5mZYukBFFPToidDRUKtEx9FK4pZm0phuYCa4KGWA@mail.gmail.com>
References: <20171017063322.11455-1-nick.desaulniers@gmail.com>
 <20171018133010.GD1302522@devbig577.frc2.facebook.com> <CAH7mPvjksNSDo4o=z51YkH4yX+gDnGXU-g59gTkOUS-pEva8sA@mail.gmail.com>
 <20171021153253.GG1302522@devbig577.frc2.facebook.com> <85d7f6eb-7869-551d-01b1-fa1712f4bd40@suse.de>
 <20171021160308.GN1302522@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=xIsderPaUVemgQJEAvynDD+DurjaxE6/CHqMxmGkKRo=;
        b=AUyAXV6au5fE6qJsoUAVA9bVAQN6IwHHMQJjIt9VTBe9nIEcHTk6gH9w6OqwX6n7tW
         9DezH+D0+Qu7tYoi/DRcQrywM+wkbbIfI3OXxWSaH9pLP2SpGP0BaNUlYiQSCpCeskwz
         Dy6bg+tqDFg+7iURRJinh0/eBrwOPglHJi25uaT5VtHL8n8S7u0gFFJDSvMnhdsVmTRm
         pArOprkoPsRcliw72ywhGFYAUHO6uXSODbm2Y2fAbUFR8MpajPGRp1Yzz3Tr86uqmE06
         FLpXkBF3bQHLA2Ic6gHaRHQyNpI9xUSI3wJ2mWOowFQpVn+ph/0h/rODH2sbT+hUkmbC
         G9Pg==
In-Reply-To: <20171021160308.GN1302522@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Aleksa Sarai <asarai@suse.de>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthias Kaehlcke <mka@chromium.org>, Michael Davidson <md@google.com>, Greg Hackmann <ghackmann@google.com>, Stephen Hines <srhines@google.com>

On Sat, Oct 21, 2017 at 9:03 AM, Tejun Heo <tj@kernel.org> wrote:
> The kernel is explicitly using GNU extended version of C and has
> always from the beginning, so not-std-c isn't a valid argument.

Ok, how about that it looks like gcc7.1 starts treating this as an error?

https://godbolt.org/g/ivzPHZ

gcc6.3 looks like it starts trying to warn about this.

I don't have a local build of gcc7.1 to verify, but it seems like
setting -std=gnu99 doesn't help.

With Clang, it seems to be a warning that can be ignored via command
line flags, but doesn't look like that's possible for newer versions
of gcc, so this will have to be addressed at some point.
