From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: reorder flexible array members of struct
 cgroup_root
Date: Wed, 18 Oct 2017 06:30:10 -0700
Message-ID: <20171018133010.GD1302522@devbig577.frc2.facebook.com>
References: <20171017063322.11455-1-nick.desaulniers@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=acpK+7vUuFvrtVCFzGUpubNAkEhs2KMKqp3fuIPdAEQ=;
        b=CIN1M4aNf6UrKcenG8bbxJpYdmfvyyx84A/vhmbfKfvC3qrVuSCS/0N+JMR+x383XU
         Omd6Dktmt8VuKV1mJmRVkJP+550GBwGkpIogOt9tNppgqm45GR4G7+z5qImnNbP5t7n5
         Hoxou4ItzcJKiAwrTf7iIsaF6NdiQneQupNbVSeXNWS/62oyDcmAsJXM4qPbVlvmGehI
         2+9hQMrIGI5XFwrQamYzo5/uwQ3l+FGywQNfa1AGnDA1sBAoE815nxPrbIQIQCeQymMh
         NRFjOWXAk4pkdpI1wI8UUEviJEHQ8ZjUbNu96UQAzdIiGaYShOQw86z7ss61TK5dwgIZ
         vgVg==
Content-Disposition: inline
In-Reply-To: <20171017063322.11455-1-nick.desaulniers@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nick Desaulniers <nick.desaulniers@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 16, 2017 at 11:33:21PM -0700, Nick Desaulniers wrote:
> When compiling arch/x86/boot/compressed/eboot.c with HOSTCC=clang, the
> following warning is observed:
> 
> ./include/linux/cgroup-defs.h:391:16: warning: field 'cgrp' with
> variable sized type 'struct cgroup' not at the end of a struct or class
> is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>         struct cgroup cgrp;
>                       ^
> Flexible array members are a C99 feature, but must be the last member of
> a struct. Structs with flexible members composed in other structs must
> also be the final members, unless using GNU C extensions.
> 
> struct cgroup_root's member cgrp is a struct cgroup, struct cgroup's
> member ancestor_ids is a flexible member.

This is silly tho.  We know the the root group embedded there won't
have any ancestor_ids.  Also, in general, nothing prevents us from
doing something like the following.

	struct outer_struct {
		blah blah;
		struct inner_struct_with_flexible_array_member inner;
		unsigned long storage_for_flexible_array[NR_ENTRIES];
		blah blah;
	};

I think we should just silence the bogus warning.

Thanks.

-- 
tejun
