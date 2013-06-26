From: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroups: Do not show inactive devices in cgroups statistics
Date: Wed, 26 Jun 2013 12:36:34 -0700
Message-ID: <CAOMFOmWWur_cpB3T=tzxTFF3pHU+nuEWKqkfkF3sbX09sVdHsQ@mail.gmail.com>
References: <1372274770-30679-1-git-send-email-anatol.pomozov@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=wKBI1DiXM1Um9gFVxcnxOWVFMSSdddJwv7UgTuTncvQ=;
        b=RYHGWiVfLC2q4Yih6bbibg4IQKVcPgANdtpaWudNGOeZm8C02AUL7S494OCioXWidE
         ImYxtn3xWzFJjH/qRFAjvcsfAvOXkOmthfIiliEJ4nb0iuVN8L8B5EeRVctkLAbQFNBo
         Zv7M64yHqtL7NGT0ikwQQ4WlS9keVnvZ5UCTge1H7wMsjWfXe+ty3CFwvRKH2M9D64Oh
         rokb400vuAXEZzSPNHuB1JoXtmOMfMHVYIx2BPE0ibyfQZxBsRvaXa/5MQeJwkQims1A
         DWbU4NmP0CRhx316cK1ZBYnkbNYCcv0moL960qSIS6cB1qI3L6WIMproPexdGHrENlUi
         8scA==
In-Reply-To: <1372274770-30679-1-git-send-email-anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi, Tejun

A little bit more context about this change.

At Google we actively use block crgoups and generate a lot of
statistics files. We have a lot of block devices per machine and
usually apps in a cgroup use only small subset of the drives. While
migrating to the latest kernel we've found that those stat files
became much bigger - now they are full of devices with zero stats.

The previous behavior seems better to me as it emphasizes device
usage. I do not know whether the change was made intentionally or
accidentally during block cgroups refactoring. If latter then the
patch above restores the previous behavior.



On Wed, Jun 26, 2013 at 12:26 PM, Anatol Pomozov
<anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Before 3.5 cgrups stats files shown only devices with activity.
> But latest kernel shows stats for all devices. The previous implementation
> looks better. Imagine a server machine with hundreds cgroups and hundreds
> iSCSI block devices (where cgroup uses just a few block devices). This
> generates *a lot* of useless data that requires more resources to
> process/store.
>
> Recover previous behaviour by skipping entries with zero stats.
>
> Signed-off-by: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  block/blk-cgroup.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index e8918ff..915c2b0 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -548,6 +548,9 @@ u64 __blkg_prfill_u64(struct seq_file *sf, struct blkg_policy_data *pd, u64 v)
>         if (!dname)
>                 return 0;
>
> +       if (!v)
> +               return 0;

I am not sure about this change. It looks like previously we've shown
zero values here as well. But I made "drop inactive devices" here to
be consistent with the change below.

Feel free to drop it if you are against it.

>
> +
>         seq_printf(sf, "%s %llu\n", dname, (unsigned long long)v);
>         return v;
>  }
> @@ -571,19 +574,23 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
>                 [BLKG_RWSTAT_ASYNC]     = "Async",
>         };
>         const char *dname = blkg_dev_name(pd->blkg);
> -       u64 v;
> +       u64 total;
>         int i;
>
>         if (!dname)
>                 return 0;
>
> +       total = rwstat->cnt[BLKG_RWSTAT_READ] + rwstat->cnt[BLKG_RWSTAT_WRITE];
> +       /* skip devices with no activity */
> +       if (!total)
> +               return 0;
> +
>         for (i = 0; i < BLKG_RWSTAT_NR; i++)
>                 seq_printf(sf, "%s %s %llu\n", dname, rwstr[i],
>                            (unsigned long long)rwstat->cnt[i]);
>
> -       v = rwstat->cnt[BLKG_RWSTAT_READ] + rwstat->cnt[BLKG_RWSTAT_WRITE];
> -       seq_printf(sf, "%s Total %llu\n", dname, (unsigned long long)v);
> -       return v;
> +       seq_printf(sf, "%s Total %llu\n", dname, (unsigned long long)total);
> +       return total;
>  }
>  EXPORT_SYMBOL_GPL(__blkg_prfill_rwstat);
>
> --
> 1.8.3
>
