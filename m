From: Nick Desaulniers <nick.desaulniers@gmail.com>
Subject: Re: [PATCH] cgroup: reorder flexible array members of struct
 cgroup_root
Date: Mon, 16 Oct 2017 23:40:51 -0700
Message-ID: <20171017064051.tudsi33f4spuyi25@lostoracle.net>
References: <20171017063322.11455-1-nick.desaulniers@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Pkx5IQ/ZIKikxY9GcZAeURWtvtlxb99xgaoy/dvdwqw=;
        b=fress4nUeQAYoTZmd0wdbFT1O64zj3dWAy7rAX63gC04YJLSq4Za8DSoiLiNDmQXBp
         ED1Ckoe/wVu4Ie1riFZz9QyT6nKRVLskE7e0ibTqKDj0XcUXUjaV/rAdfXkma1rJn4Qf
         zpBGV9lNphs1D4V7zSoNbnL/+yv6wZw43z5OKsEZ8FVF1My9kGWPWElXiGUbORS9pldK
         vjWTOChSXncFHz7fFpt+QtJSOW/NiUwAOjeLwNkJvW8EiRQvJ/jblF3RRO8dtgwqM6U7
         4pwjRNmy9LcficCs7ubQDiW3bJqUqJiALwS5OwEnL+nSHecWS2WJG13hU/xfOvl5q08h
         VMoA==
Content-Disposition: inline
In-Reply-To: <20171017063322.11455-1-nick.desaulniers@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 16, 2017 at 11:33:21PM -0700, Nick Desaulniers wrote:
> When compiling arch/x86/boot/compressed/eboot.c with HOSTCC=clang, the

Actually, not sure this is because HOSTCC was specifically clang, I
think that could be reworded to `When compiling ... with Clang, the
...`.
