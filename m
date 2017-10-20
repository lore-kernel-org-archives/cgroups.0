From: Nick Desaulniers <nick.desaulniers@gmail.com>
Subject: Re: [PATCH] cgroup: reorder flexible array members of struct cgroup_root
Date: Fri, 20 Oct 2017 00:15:55 -0700
Message-ID: <CAH7mPvjksNSDo4o=z51YkH4yX+gDnGXU-g59gTkOUS-pEva8sA@mail.gmail.com>
References: <20171017063322.11455-1-nick.desaulniers@gmail.com> <20171018133010.GD1302522@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=uB30AgMISvBWCqqu25VaZCMvGVeuyGpnL1JDldPiW2Q=;
        b=sNuVMHPlZFu+Jh1jwFwUuOC6oMK/E++kjF7f4YNN1DSblsrlAetRJQ/kdtPO9SAVF9
         JGHCKhL3Y4aZ8W+TQ0VsAft4Px6M6j9vrTCcrTziQQVALqfdh5AEc01gcgHooivaAQL7
         pb8DozTXs1lJJdGeaxss0TMJLLuMNL4+8s9DOClXP21JPG4epnqsPNZdZb1DIb3R0oX/
         3G+B4m14/Og9M8TIAMJtKmWkxMXgL5EeqP4U0RYen7ZgbIjHOzJt2dc5ai+0bUOsKyO2
         yIZ09GiFJxAh6tRx/cLzyTigTyRaPMbPaElGAZndzHw5E0ZA2q9ap/qsaxAglCfZbHEM
         eqwQ==
In-Reply-To: <20171018133010.GD1302522@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthias Kaehlcke <mka@chromium.org>, Michael Davidson <md@google.com>, Greg Hackmann <ghackmann@google.com>, android-llvm@google.com

On Wed, Oct 18, 2017 at 6:30 AM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Oct 16, 2017 at 11:33:21PM -0700, Nick Desaulniers wrote:
>> When compiling arch/x86/boot/compressed/eboot.c with HOSTCC=clang, the
>> following warning is observed:
>>
>> ./include/linux/cgroup-defs.h:391:16: warning: field 'cgrp' with
>> variable sized type 'struct cgroup' not at the end of a struct or class
>> is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>>         struct cgroup cgrp;
>>                       ^
>> Flexible array members are a C99 feature, but must be the last member of
>> a struct. Structs with flexible members composed in other structs must
>> also be the final members, unless using GNU C extensions.
>>
>> struct cgroup_root's member cgrp is a struct cgroup, struct cgroup's
>> member ancestor_ids is a flexible member.
>
> This is silly tho.  We know the the root group embedded there won't
> have any ancestor_ids.

Sure, but struct cgroup_root is still declared as having a struct
cgroup not declared as the final member.

> Also, in general, nothing prevents us from
> doing something like the following.
>
>         struct outer_struct {
>                 blah blah;
>                 struct inner_struct_with_flexible_array_member inner;
>                 unsigned long storage_for_flexible_array[NR_ENTRIES];
>                 blah blah;
>         };

At that point, then why have the struct with flexible array member in
the first place?

>> or specific location of the member cgrp within struct cgroup_root AFAICT.
> I think we should just silence the bogus warning.

Is the order of the members actually important?  Otherwise it seems
that we're taking advantage of a GNU C extension for no real reason,
which is what I'm trying to avoid.  Please reconsider.
