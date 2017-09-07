From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: memcontrol: use per-cpu stocks for socket memory uncharging
Date: Thu, 7 Sep 2017 11:44:12 -0700
Message-ID: <CALvZod5zP=LL=LhD0WX-zX4mPbn7F_obQmpCrrin9YuBQHJLow@mail.gmail.com>
References: <20170829100150.4580-1-guro@fb.com> <20170829192621.GA5447@cmpxchg.org>
 <20170830105524.GA2852@castle.dhcp.TheFacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=gWKUpQErXXZ8P246AifU2ADtDbCdM1Toe9akwEMxKY4=;
        b=ND84p2Cn6rKx2nPZRaORAN/mSVg8n6eMjG3j9cHcEZzfokxVUpOdPtC6Zv0gOlVAhh
         NxP5fvdrFgLwPfWr6Wwvz1brVq60rbeocjpRBeh+pSVpCz3kksJMmo0ilEtWgT82mDrw
         HZNmtR7DnRHHFonaxZiIkqSOuLwxyWPJVzY3qJn8EPr0SCGxoat63wfnOUgOPyTXO0+v
         W8xTuKBUKN2SCmTGAgZrZPiSjwgCmZXaGITRfpGMXksA9P0uBoQrnKcdCr5W7n/Et5i9
         BIEAIZyXjCkDK+EelVJVluUPfN2BZMOxS6yp/ushQMCLv93oyOjiUCMvGgu0/3GKDWYM
         Oz1g==
In-Reply-To: <20170830105524.GA2852@castle.dhcp.TheFacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, kernel-team@fb.com, LKML <linux-kernel@vger.kernel.org>

>> As far as other types of pages go: page cache and anon are already
>> batched pretty well, but I think kmem might benefit from this
>> too. Have you considered using the stock in memcg_kmem_uncharge()?
>
> Good idea!
> I'll try to find an appropriate testcase and check if it really
> brings any benefits. If so, I'll master a patch.
>

Hi Roman, did you get the chance to try this on memcg_kmem_uncharge()?
