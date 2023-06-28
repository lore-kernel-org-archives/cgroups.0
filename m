From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Wed, 28 Jun 2023 10:34:34 -1000
Message-ID: <ZJyZWtK4nihRkTME@slm.duckdns.org>
References: <CAJuCfpGoNbLOLm08LWKPOgn05+FB1GEqeMTUSJUZpRmDYQSjpA@mail.gmail.com>
 <20230628-meisennest-redlich-c09e79fde7f7@brauner>
 <CAJuCfpHqZ=5a_2k==FsdBbwDCF7+s7Ji3aZ37LBqUgyXLMz7gA@mail.gmail.com>
 <20230628-faden-qualvoll-6c33b570f54c@brauner>
 <CAJuCfpF=DjwpWuhugJkVzet2diLkf8eagqxjR8iad39odKdeYQ@mail.gmail.com>
 <20230628-spotten-anzweifeln-e494d16de48a@brauner>
 <ZJx1nkqbQRVCaKgF@slm.duckdns.org>
 <CAJuCfpEFo6WowJ_4XPXH+=D4acFvFqEa4Fuc=+qF8=Jkhn=3pA@mail.gmail.com>
 <2023062845-stabilize-boogieman-1925@gregkh>
 <CAJuCfpFqYytC+5GY9X+jhxiRvhAyyNd27o0=Nbmt_Wc5LFL1Sw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687984477; x=1690576477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ipbLnYvlGYQvDEihyiPuXfdid6qmlxbdUrEvPFMafw4=;
        b=opSL76LDc984zvWM3786OidbBT25+1HD1mQMziNNFfP4Zsljw5U+R1LwpfgRjqakdu
         lyO3voeeVszuMA+bdl57FtM0OiOwdjEhMGusRh8PrEwfT+W94UMOraQg8L2LqPIZzDp5
         nLnAxenahvm+RDN1eQWrhVw+chYXpSUC5++RVkiMEDXV2tKxMQkMlIdbYtS882Wp3wAq
         3UqdPomtMd0EEcrYiQQZw8VYnUHvixfbxCSUKSZgILtO98HCfujdnQMHBg2enLrGn11M
         FqODDg+KVXkLLJxNQLt1RyfgE/1C3D9Kg+00mZoAc9V4Y02ZyUFj27JJsXB3fDudmRsQ
         vwXw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJuCfpFqYytC+5GY9X+jhxiRvhAyyNd27o0=Nbmt_Wc5LFL1Sw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>, peterz@infradead.org, lujialin4@huawei.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@redhat.com, ebiggers@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com

Hello, Suren.

On Wed, Jun 28, 2023 at 01:12:23PM -0700, Suren Baghdasaryan wrote:
> AFAIU all other files that handle polling rely on f_op->release()
> being called after all the users are gone, therefore they can safely
> free their resources. However kernfs can call ->release() while there
> are still active users of the file. I can't use that operation for
> resource cleanup therefore I was suggesting to add a new operation
> which would be called only after the last fput() and would guarantee
> no users. Again, I'm not an expert in this, so there might be a better
> way to handle it. Please advise.

So, w/ kernfs, the right thing to do is making sure that whatever is exposed
to the kernfs user is terminated on removal - ie. after kernfs_ops->release
is called, the ops table should be considered dead and there shouldn't be
anything left to clean up from the kernfs user side. You can add abstraction
kernfs so that kernfs can terminate the calls coming down from the higher
layers on its own. That's how every other operation is handled and what
should happen with the psi polling too.

Thanks.

-- 
tejun
