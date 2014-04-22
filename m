From: Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: [PATCH] hugetlb_cgroup: explicitly init the early_init field
Date: Tue, 22 Apr 2014 15:01:04 +0800
Message-ID: <CAHz2CGXsvdtVdwZfyFAwtRHJ_vkeJZXtLv4fTGTYEeEwN7H6Qw@mail.gmail.com>
References: <1398144620-9630-1-git-send-email-nasa4836@gmail.com> <CAJd=RBA6ZUZ2UBetmcwGciqY8snme-aY60ZhW9F=8CO6kDzMBA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=cX/HszSRnIaakUAgelyIeLU5+1PJHNK5DpVC+a4w+ag=;
        b=NnG2JjpGFpH9i4NuWPbgQ3Wep5mM0E6y5S2Oy+gAiZ1rW+D9gp5maQJwaCU9Rl2uE0
         4fCofOg1woEag+P1OGKVr9PVmpQzzxaJzSI0sBOZl3Wcn/np6EizIPHgokwXMdIrh7wP
         kdduUdcDiYT4mhx3/K9jwTXQuNAc1MN5kU8lle9s0dp4uhepx90SlJHXln4w0BMapE4u
         7KooTIAqN4dyCYIsSry5PeDi8xioPUQefcE3XohOlCg/8aXS20XqUyCbuQWl/nqodvTq
         D30YvOcT+MU9qDDrdA+XDtbL21agYcQSVjBoPNFV8BRrCQC5pav9KpBd43/GdG4jl5kd
         2Epg==
In-Reply-To: <CAJd=RBA6ZUZ2UBetmcwGciqY8snme-aY60ZhW9F=8CO6kDzMBA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hillf Danton <dhillf@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org, Cgroups <cgroups@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

Hi, hillf,

On Tue, Apr 22, 2014 at 2:47 PM, Hillf Danton <dhillf@gmail.com> wrote:
> But other fields still missed, if any. Fair?

yep, it is not fair.

Sure for this global variable struct, if not initailized, its all
fields will be initialized
to 0 or null(depending on its type).  The point here is no to deprive
the rights of
compiler/linker of doing this initialization, it is mainly for
documentation reason.
Actually this field's value would affect how ->css_alloc should implemented.

Concretely, if early_init is nonzero, then ->css_alloc *must not* call kzalloc,
because in cgroup implementation, ->css_alloc will be called earlier before
mm_init().

I don't think that the value of one field(early_init) has a so subtle
restrition on the
another field(css_alloc) is a good thing, but since it is there,
docment it should
be needed.


Thanks,
Jianyu Zhan

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
