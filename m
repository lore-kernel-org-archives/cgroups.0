From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/6] memcg: track shared inodes with dirty pages
Date: Thu, 15 Jan 2015 14:08:40 -0500
Message-ID: <20150115190840.GD28195@htj.dyndns.org>
References: <20150115180242.10450.92.stgit@buzz>
 <20150115184914.10450.51964.stgit@buzz>
 <20150115185543.GA28195@htj.dyndns.org>
 <CALYGNiPY2K6F+OFoCV5XShrXaQOiyGXreR=4TC=Mp7axTiF0YQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Iz9PAHbqGo+80nCUyvWMMPjybYtAIurNyK1cLUyVUlo=;
        b=JAT3HapvDi27GQF7Auih7IWSvVPBBK2DDHiwNzIoYGU04wrHuZv8oY0HZrplecpTpg
         k7B5ZY+xz+KGvlXnWVS0wZC4WF0l/w476GrVbwTn9+uXdS6o9JSV2H1ZPII4QCN4gZAU
         xM8Cqb9vIk1F4XGuJqY+uWAA3pSzKizVq8CKuQ1vVIJxZ9k56kx0UItdpWeHDqj19eVp
         SzZEGG2USskPiEtU0e44L/Gxi0br9+0/AOCOu0NqwnbdAh3XbZwutlBra95flz8/Ec0i
         AojwWCiC8BlPTBscYV4u9pxmVSdqHmVwcQP23qFde42iwloVz2SDhOdIeX8Nky36tnRQ
         MfHg==
Content-Disposition: inline
In-Reply-To: <CALYGNiPY2K6F+OFoCV5XShrXaQOiyGXreR=4TC=Mp7axTiF0YQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Konstantin Khebnikov <khlebnikov@yandex-team.ru>, "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org, Roman Gushchin <klamm@yandex-team.ru>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Hello,

On Thu, Jan 15, 2015 at 11:04:49PM +0400, Konstantin Khlebnikov wrote:
> I know. Absolutely accurate per-page solution looks too complicated for me.
> Is there any real demand for accurate handling dirty set in shared inodes?
> Doing whole accounting in per-inode basis makes life so much easier.

Ah, yeah, patch #3 arrived in isolation, so I thought it was part of
something completely different.  I definitely thought about doing it
per-inode too (and also requiring memcg to attribute pages according
to its inode rather than individual pages).  I'll look into the
patchset and try to identify the pros and cons of our approaches.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
