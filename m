From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 1/1] cgroup: limit cgroup psi file writes to processes
 with CAP_SYS_RESOURCE
Date: Wed, 1 Mar 2023 10:40:05 -0800
Message-ID: <CAJuCfpH1OsRH15p9PBxuCXrp8RrSiP5u4XQouuO-zOUxCB-zbw@mail.gmail.com>
References: <20230301014651.1370939-1-surenb@google.com> <Y/8fNrNm1B2h/MTb@dhcp22.suse.cz>
 <CAJuCfpERczW1YhEW0fN3p2zrdDj-Ec_pCONH6SQVEwTj0BHYMw@mail.gmail.com> <Y/+a7fczvsVe2lPP@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677696017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0VNgf/r1TnHipquaSqm1nBgcfCj1sznNvb3fMKCfdzk=;
        b=COdiTXCTNt65uxq2qiDXYzfPtnXK1e4ui6Q+vUpUn8iwglyQFGsBmRbIApA3qffQE9
         CWYk1Ea125YBWTqc9drTxqJWMMhBNLfJXyUfM2xFbiIvYFEM8NTWo9EcvoXpGPLzmDQu
         N5dJ7eEJRPWkmZEu0Tcd2cXRavT48kX3cTotQhqznDkkzebA1Rnh8bfLFbV/Ijl9DptM
         toDwFGvlYoQWsqC5klnDfy25CN+wNfIOdeX3fxh97zq3LMzUERHqE5kkSCysr/KxuYPP
         DneIapDgvV0LtVULE9BmwlCaPnwjpOvSGRHXO7IsZMo4f/eRMa/2ZuD3czVvUo4ScYMC
         lBIA==
In-Reply-To: <Y/+a7fczvsVe2lPP@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, lizefan.x@bytedance.com, peterz@infradead.org, johunt@akamai.com, quic_sudaraja@quicinc.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed, Mar 1, 2023 at 10:35=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Wed 01-03-23 10:05:36, Suren Baghdasaryan wrote:
> [...]
> > Yes but hopefully my argument about keeping this and min period
> > patches separate is reasonable?
>
> I am not questioning that. The practical advantage to squash the two
> changes is that in case of the CAP_SYS_RESOURCE you do not have to
> explicitly think about reverting the min constrain as well. I do not
> think reverting one without the other is good.

Ok, I'm fine with having both changes in the same patch. Will post v2
later today. Thanks!

>
> --
> Michal Hocko
> SUSE Labs
