From: weiping zhang <zwp10758-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] blk-throttle: export io_serviced_recursive, io_service_bytes_recursive
Date: Sat, 30 Dec 2017 01:17:24 +0800
Message-ID: <CAA70yB7wTVHKLdCGsgCzVi5thtwuU5buTA2acDyv_gABY8GDpw@mail.gmail.com>
References: <20171211145621.GA2115@localhost.didichuxing.com> <20171211151705.GG2421075@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=swvYys6vG/JOlIXwn0jtl5F4y7w4Z8JO0K5lmQWMlYk=;
        b=RYGP9dVaqSVqRjM1AoYubkJEfsGp6ZaqH1Ptb40oTyJl5Fk/gRtuoHgKGMeGTUdHsq
         QuSZJabcHF7a9eXqW1xbqBzr1EjMnFxBbImau6GCn6Ftvf3HPsd4RZ23bQ6zrjlLiQcG
         sfzGbEP2slYYDe6oZo95S0oOR/0Kv5ncX8tZcLqx5Yubwn9orUdPlIHAGa/LXGJ3hxxs
         KOTDW74HE5ayUjTSjgiNfr74o3UjrHVedcVQQFgCVdqXcD1SzsLjfJZRGPUfDg0hRZur
         734PUp1XM1vEWYpdDk2LvnjD+PleNsvlI/LdL6+YdEvcvC4FA0N7gbt5dNKmqzbC3mRZ
         +r6A==
In-Reply-To: <20171211151705.GG2421075-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

2017-12-11 23:17 GMT+08:00 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> On Mon, Dec 11, 2017 at 10:56:25PM +0800, weiping zhang wrote:
>> export these two interface for cgroup-v1.
>>
>> Signed-off-by: weiping zhang <zhangweiping-j11cvHKnkmPwvR0lvYjcXw@public.gmane.org>
>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Thanks.
>

Hi Jens,

these two interface are useful to collect blkcg info, would you pick it up ?

Thanks
