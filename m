From: Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: [PATCH 1/2] mm/memcontrol.c: remove meaningless while loop in mem_cgroup_iter()
Date: Tue, 22 Apr 2014 18:58:11 +0800
Message-ID: <CAHz2CGUZyv-dvUUoSi2Vk_vgPAMqRN4yEg4F4XsKQ8udHeo2bQ@mail.gmail.com>
References: <1397861935-31595-1-git-send-email-nasa4836@gmail.com>
 <20140422094759.GC29311@dhcp22.suse.cz> <CAHz2CGWrk3kuR=BLt2vT-8gxJVtJcj6h17ase9=1CoWXwK6a3w@mail.gmail.com>
 <20140422103420.GI29311@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=FRxuaczFlD7Jmz/Q4PvulxAVo44zBmhmjSlS/gAzAYo=;
        b=pIZ3HextgIGvtrhGerfcB5TS7ZBqIENqw5+rNgnYwmBv4JfpgAbra/xje+xbg1nydy
         k1SJ09RUqeJ8FkTBaMDlaTdRokf9nKbSP2aNeUBfDzz7YFCzgkaVoNqleiGAN9gNWG91
         Hc6ViV86BDMEHELdHW8HBeW2oZXjJpZYTQGvHaOq3IucwmE0l51Vg7XMpS1oJ8ONIRuL
         PE5TeIwj9T8EKmtSpyyRPn/8zm1TGGHQRCuPJrV0UFozJAQ/vTXL32Gi/e2zNr06LsQP
         nZVaRC/FGoTAwhDaLXX7kJLM9NJfJhbpb+wFYobCuKK700zA8fT6r/GAfnfIE1sUcTvj
         ZIXA==
In-Reply-To: <20140422103420.GI29311@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, kamezawa.hiroyu@jp.fujitsu.com, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, Apr 22, 2014 at 6:34 PM, Michal Hocko <mhocko@suse.cz> wrote:
> Sorry, I should have been more specific that I was talking about
> mem_cgroup_reclaim_cookie path where the iteration for this particular
> zone and priority ended at the last node without finishing the full
> roundtrip last time. This new iteration (prev==NULL) wants to continue
> and it should start a new roundtrip.
>
> Makes sense?

Hi, Michal,

Good catch, it makes sense !
This reminds me of my draft edition of this patch, I specifically handle
this case as:

if (reclaim) {
               if (!memcg ) {
                              iter->generation++;
                              if (!prev) {
                                    memcg = root;
                                    mem_cgroup_iter_update(iter, NULL,
memcg, root,  seq);
                                    goto out_unlock:
                              }
              }
              mem_cgroup_iter_update(iter, last_visited, memcg, root,
                                seq);
              if (!prev && memcg)
                        reclaim->generation = iter->generation;
}

This is literally manual unwinding the second while loop, and thus omit
the while loop,
to save a   mem_cgroup_iter_update() and a mem_cgroup_iter_update()

But it maybe a bit hard to read.

If it is OK, I could resend a new one.

Thanks,
Jianyu Zhan

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
