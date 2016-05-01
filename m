From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: allow management of subtrees by new cgroup namespaces
Date: Sun, 1 May 2016 23:20:53 +1000
Message-ID: <CAOviyaikiTOCveWNuA+Och4SvHnXmZ07s0WDjc-JVo5avm6g-g@mail.gmail.com>
References: <1462107838-9843-1-git-send-email-asarai@suse.de>
	<1462107838-9843-2-git-send-email-asarai@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cyphar-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=LMa9uqr0h2sCB5nK//OUmmJQtYZ7fUDakCq/ObUVt8w=;
        b=wLsSHcgZ15vUAa5J14Ci0IxspIkbHg8mCw8wbmE4vE6BKRs8S0olTNX5meHdPbwZ/r
         eB8CvqS4bk+l5cX7yaBq9fMe0HXM6rsEkpPK5U9tWIxYl4q9hysAPTzgN3vBHjYFjmsG
         kIrj6s0De2Y2q3Gx71+JYbULN8nOAPwVBbRXsp9KHm+qzDDkkbofjLWPFop0NFNqsDf7
         Z1nJxh3Np85dt5NDDdcwLGJp5GeawZPL4lCzUJOH4jQXUiWTNkF/eKO0O07Xj9O1RgX8
         9EUhQChTfIrpB5jLky8UJIm8uZL78gC9rSyZIvyz341ClX31gr5q34puIjjhDMmmfWYC
         +dJg==
In-Reply-To: <1462107838-9843-2-git-send-email-asarai-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev <dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org>

> +err_unset_mode:
> +       /* Clean up the mode changes. */
> +       do_each_subsys_mask(ss, ssid, updated_mask) {
> +               struct kernfs_node *kn = cset->subsys[ssid]->cgroup->kn;
> +
> +               kernfs_break_active_protection(kn);
> +               cgroup_kn_set_mode(kn, mode[ssid]);
> +               kernfs_unbreak_active_protection(kn);
> +       } while_each_subsys_mask();

Sorry, I just realised this doesn't unlock all of the relevant locks
in the error path. I'll send an updated patch.

-- 
Aleksa Sarai (cyphar)
www.cyphar.com
