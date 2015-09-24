From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] cgroup: fix seq_show_option merge with legacy_name
Date: Thu, 24 Sep 2015 11:35:00 -0700
Message-ID: <CAGXu5jLtaEdTmX2QzgfrB=J=tWaoc3Bt_uAstep8UyKdh8v-OQ@mail.gmail.com>
References: <20150908183043.GA23974@www.outflux.net>
	<20150924183328.GA2163@charon>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        bh=s5owyF7kPB27tLCjQ8eVZMOelj8gua7/wfeZeqL7ins=;
        b=V44ewZ8uHFpZC1gLVGy5zlDtiP5HZUUkQnpTJB8Z4n8XB8nYeArbA3r48hDhDN8fnk
         3UCJUG+najaPwwgiV5WFcnaE6ZUicdCs8SLY5pCP7SB639ICbaJFlOy+iHE/7A8UU0ad
         SKpw1EIvh+RGG1LmOVk4We4Mhqd2Bhv5CJfaYz9hVtM/l5ysspSC9P2d4qXMbMEFi7+G
         dAK0fW98klM9LfhVLXIUeWjqQx5JFflRhkA4TKVqz/I5h/hKndTT0b7wjYX0PlqzgSJ9
         rYvIZCBvZaNklgcOkTeqESqurM70Fua+rdeI0nkEfDZdWCL2N8+ls9V92WzirkfaMeeb
         36Fg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        bh=s5owyF7kPB27tLCjQ8eVZMOelj8gua7/wfeZeqL7ins=;
        b=QDzpOEdUMzhZyLC9KrftWYG7lQLbseTkzuS1RFQbSD1rC0c4Q56jk5OwkvHlA6Coql
         7E+hxfmmFVl8+XaavgCGVx5H+u6RwTAdnj+FMwmnw/wMfiuIdqWwVRXgTxymUk3Nx67M
         IKyoy808arIDqys8jDgZZbrq70sMGB6T1isQk=
In-Reply-To: <20150924183328.GA2163@charon>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Luis Henriques <luis.henriques@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Cgroups <cgroups@vger.kernel.org>, "# 3.4.x" <stable@vger.kernel.org>

On Thu, Sep 24, 2015 at 11:33 AM, Luis Henriques
<luis.henriques@canonical.com> wrote:
> On Tue, Sep 08, 2015 at 11:30:43AM -0700, Kees Cook wrote:
>> When seq_show_option (068acf2ee776) was merged, it did not correctly
>> collide with cgroup's addition of legacy_name (3e1d2eed39d8) changes=
=2E This
>> fixes the reported name.
>>
>
> Since a068acf2ee77 ("fs: create and use seq_show_option for escaping"=
)
> has been CC'ed to stable, shouldn't this be tagged to stable too?
>
> (This is upstream commit 61e57c0c3a37 "cgroup: fix seq_show_option
> merge with legacy_name".)

If the cgroup change when to stable also, then yes.

-Kees

>
> Cheers,
> --
> Lu=C3=ADs
>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  kernel/cgroup.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index a8538e443784..2cf0f79f1fc9 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1342,7 +1342,7 @@ static int cgroup_show_options(struct seq_file=
 *seq,
>>       if (root !=3D &cgrp_dfl_root)
>>               for_each_subsys(ss, ssid)
>>                       if (root->subsys_mask & (1 << ssid))
>> -                             seq_show_option(seq, ss->name, NULL);
>> +                             seq_show_option(seq, ss->legacy_name, =
NULL);
>>       if (root->flags & CGRP_ROOT_NOPREFIX)
>>               seq_puts(seq, ",noprefix");
>>       if (root->flags & CGRP_ROOT_XATTR)
>> --
>> 1.9.1
>>
>>
>> --
>> Kees Cook
>> Chrome OS Security
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kern=
el" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/



--=20
Kees Cook
Chrome OS Security
