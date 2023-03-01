From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup: limit cgroup psi file writes to processes
 with CAP_SYS_RESOURCE
Date: Wed, 1 Mar 2023 11:36:58 -0800
Message-ID: <CAJuCfpH=vEObrnSkqyk2BfeG0Jqgz2T4GxrS7=xJ3Ts2zj0A7w@mail.gmail.com>
References: <20230301014651.1370939-1-surenb@google.com> <Y/8fNrNm1B2h/MTb@dhcp22.suse.cz>
 <CAJuCfpERczW1YhEW0fN3p2zrdDj-Ec_pCONH6SQVEwTj0BHYMw@mail.gmail.com>
 <Y/+a7fczvsVe2lPP@dhcp22.suse.cz> <CAJuCfpH1OsRH15p9PBxuCXrp8RrSiP5u4XQouuO-zOUxCB-zbw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677699429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QN5p7z1WK4bckACT7Rmjh2flVU52vLPk6a4cmtTmWCM=;
        b=Bz3Gg87YDUOZRW3JtWlnTSRav9KQ3c8UoFRle8RRsFj4E8JL/6YPrh+cbeKQvNJrSI
         QMDpNr81KkfsEda0yEywOHnC+W2xKgL2Ft6WVjYTsKQOeC1h3KVcSLXhiUMyy8SnnowZ
         AvnOHJ70aVW5+ohbUw4QNQ/tpW2+8xTwez8SZjiA43cyddyn9r9oJ5V0erPMEqP58l0c
         hZnbK+zPGprvS608QVNuofuBnuktaml9uU+vJsBuz4YC+hK8HHLgPyItbqzCSt0YzPe9
         g171Iu8gTmGP5yXq9dTY2t6ZDaA3Teq+g2BPfaRFOIcY9M+dgqFZOZJyLxQBQ7lB0odM
         oWIg==
In-Reply-To: <CAJuCfpH1OsRH15p9PBxuCXrp8RrSiP5u4XQouuO-zOUxCB-zbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 1, 2023 at 10:40=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Wed, Mar 1, 2023 at 10:35=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wr=
ote:
> >
> > On Wed 01-03-23 10:05:36, Suren Baghdasaryan wrote:
> > [...]
> > > Yes but hopefully my argument about keeping this and min period
> > > patches separate is reasonable?
> >
> > I am not questioning that. The practical advantage to squash the two
> > changes is that in case of the CAP_SYS_RESOURCE you do not have to
> > explicitly think about reverting the min constrain as well. I do not
> > think reverting one without the other is good.
>
> Ok, I'm fine with having both changes in the same patch. Will post v2
> later today. Thanks!

Didn't call it v2 since the title had to be changed. The new patch is
posted at: https://lore.kernel.org/all/20230301193403.1507484-1-surenb@goog=
le.com/

>
> >
> > --
> > Michal Hocko
> > SUSE Labs
