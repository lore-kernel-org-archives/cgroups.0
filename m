From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] misc_cgroup: introduce misc.events and
 misc_events.local
Date: Fri, 10 Sep 2021 12:33:06 +0200
Message-ID: <20210910103306.GA24156@blackbody.suse.cz>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <20210909143702.GA13761@blackbody.suse.cz>
 <CAHVum0eGN=v1kLqHQg7HBESp8Kg4aGZFNd4XTpxfeyToXPmPVg@mail.gmail.com>
 <8259b666-f3a4-6788-880c-38d679414bcb@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631269987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VuD6HYOFCTA+t/pZ+ukbmTtyDG3QvPABmFJv2yqsIU4=;
        b=mMe6RbfGZXixrP2ucNxm8af8RpQwXsefvWROdXE9QrJXQ1N8d+PdYmk7IX7odV5t47MMYm
        qROWOWAEmimRcB8UkU/UoV/PuBnm8MJFn7T2ZUMfimW7SgwWWuxfHy8Af42BcLwXWTmbH3
        t9PPGInQY8hUuPUIxeudI2/7po/voNQ=
Content-Disposition: inline
In-Reply-To: <8259b666-f3a4-6788-880c-38d679414bcb-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 10, 2021 at 01:20:37PM +0800, brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
> Yeah, this is more reasonable. But there is still one question, whether we
> need to be consistent with other cgroup subsystems, events and events.loc=
al
> under v1 should not support hierarchy=EF=BC=9F

My take is that it's acceptable to present the v2-like files in v1 too
for the sake of simplicity since:
- this is not used yet,
- the v1 is less conventional and
- the presence of events.local would cater even to cases with tasks in
  inner nodes.

It'd be good to have Tejun's insight on this too.

Michal
