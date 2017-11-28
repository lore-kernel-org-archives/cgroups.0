From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm, memcg: fix mem_cgroup_swapout() for THPs
Date: Tue, 28 Nov 2017 12:09:23 -0800
Message-ID: <CALvZod6AK08kugQveutunDsOUabSZ0PUKEeb+-a2RdQ16+uO4Q@mail.gmail.com>
References: <20171128161941.20931-1-shakeelb@google.com> <20171128200005.67grhk2arm2ivgug@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Rs/GGXy/dXHrgmQ6NtpXNifM2h4fERcHJLi4px/+T1w=;
        b=o+Yrbp7jtnWvmWLL3TfnDRXOvaerHezn0okwUZMrBpRd6G3orocZmpt1EFSNIegHow
         OBPhHR/Sf63j7KrErfIv0EI6/fKElCPcjXQaFG2ULrh+N3+F2h1IJJTJX0uvL+mcVCRy
         nkC9uA4zz3ocVHUZdNYt23DxXHumc+GDQd/CNK86ZGviEsKaLTFVw7belz58zM/MHAP2
         LLjgNmuNFH//dEYQs3vmeSewN74UoTFIh/A4kVoxMgebDJHXaZK1mZDJWmRbWvZEQg06
         FbTaD1A0k1R3xsV8GvYLu2VRvRaj0yR0LIX42Gi66svML38U8aDrqw4uj6e+MmO+mtGD
         k8Kg==
In-Reply-To: <20171128200005.67grhk2arm2ivgug@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, stable@vger.kernel.org

On Tue, Nov 28, 2017 at 12:00 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Tue 28-11-17 08:19:41, Shakeel Butt wrote:
>> The commit d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout()
>> support THP") changed mem_cgroup_swapout() to support transparent huge
>> page (THP). However the patch missed one location which should be
>> changed for correctly handling THPs. The resulting bug will cause the
>> memory cgroups whose THPs were swapped out to become zombies on
>> deletion.
>
> Very well spotted! Have you seen this triggering or you found it by the
> code inspection?
>

By code inspection.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
