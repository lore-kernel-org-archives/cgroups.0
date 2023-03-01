From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 1/1] cgroup: limit cgroup psi file writes to processes
 with CAP_SYS_RESOURCE
Date: Wed, 1 Mar 2023 10:05:36 -0800
Message-ID: <CAJuCfpERczW1YhEW0fN3p2zrdDj-Ec_pCONH6SQVEwTj0BHYMw@mail.gmail.com>
References: <20230301014651.1370939-1-surenb@google.com> <Y/8fNrNm1B2h/MTb@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677693948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uX8jmiHZcgYXj8u2P74s/De46LZgaxk18Jsejs4CDXw=;
        b=F4Tge1VkHhBLEu87APuX+c1FBFZuQ/236EIgqsa2CLAghV4MU4ktWNxdD4wbxYlLnG
         8Jz5OVtY0G4gUHBsHAUXgUuH3ztxqwsOiC8zJryAUnVUICBu/WSrngNVUHUKqqlFwKRo
         twWP+HY0so8JHoUhrK0FYhjLb3iJunbdtoZmQL+PZhLFN3CZWUPGY7tug8DPT0K0GRio
         2y69fGAW3CjaTSWmBcVf90tdB5iHUOvM8g6UdSZK38pahBHs1bkhZI4YgUC/DBfZFEuR
         6YZdJx6Ijq0D/SCoGQsB3SVT1Q2QZA67NO8fHXg9I5OE8119UaOTW6PvjnaS/XuMPdMa
         4kxg==
In-Reply-To: <Y/8fNrNm1B2h/MTb@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, lizefan.x@bytedance.com, peterz@infradead.org, johunt@akamai.com, quic_sudaraja@quicinc.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed, Mar 1, 2023 at 1:47=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Tue 28-02-23 17:46:51, Suren Baghdasaryan wrote:
> > Currently /proc/pressure/* files can be written only by processes with
> > CAP_SYS_RESOURCE capability to prevent any unauthorized user from
> > creating psi triggers. However no such limitation is required for
> > per-cgroup pressure files. Fix this inconsistency by requiring the same
> > capability for writing per-cgroup psi files.
> >
> > Fixes: 6db12ee0456d ("psi: allow unprivileged users with CAP_SYS_RESOUR=
CE to write psi files")
>
> Is this really a regression from this commit? 6db12ee0456d is changing
> permissions of those files to be world writeable with the
> CAP_SYS_RESOURCE requirement. Permissions of cgroup files is not changed
> and the default mode is 644 (with root as an owner) so only privileged
> processes are allowed without any delegation.

Agree, the Fixes line here is not valid. I will remove it.

>
> I think you should instead construct this slightly differently. The
> ultimate goal is to allow a reasonable delegation after all, no?

Yes.

>
> So keep your current patch and extend it by removing the min timeout
> constrain and justify the change by the necessity of the granularity
> tuning as reported by Sudarshan Rajagopala. If this causes any
> regression then a revert would also return the min timeout constrain
> back and we will have to think about a different approach.

I think adding CAP_SYS_RESOURCE check is needed even if we keep the
min timeout capped like today. Without it one could create multiple
cgroups and add a trigger into each one, therefore creating an
unlimited number of "psimon" kernel threads. At some point I expect
them to affect system performance because even at high polling
intervals they still consume some cpu resources. So, this change I
think is needed regardless of the change to min polling period and I
would suggest keeping them separate.

>
> The consistency with the global case is a valid point only partially
> because different cgroups might have different owners which is not
> usually the case for the global psi interface, right?

Correct.

>
> Makes sense?

Yes but hopefully my argument about keeping this and min period
patches separate is reasonable?
Thanks,
Suren.

> --
> Michal Hocko
> SUSE Labs
