From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -next v5 0/3] support concurrent sync io for bfq on a
 specail occasion
Date: Mon, 23 May 2022 10:59:02 +0200
Message-ID: <20220523085902.wmxoebyq3crerecr@quack3.lan>
References: <20220428120837.3737765-1-yukuai3@huawei.com>
 <d50df657-d859-79cf-c292-412eaa383d2c@huawei.com>
 <61b67d5e-829c-8130-7bda-81615d654829@huawei.com>
 <81411289-e13c-20f5-df63-c059babca57a@huawei.com>
 <d5a90a08-1ac6-587a-e900-0436bd45543a@kernel.dk>
 <55919e29-1f22-e8aa-f3d2-08c57d9e1c22@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653296344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h1QuB3M+BmdTEHvDbJ/48/qLXP8QUk8L4+wxn4b3JqE=;
        b=rZ+SQ9qfiHZw+b4x1x93KOH97ACbM8txlwl7+4DjUI1B9uu2F8p5huYe0KZJV6PhmLenGI
        /9pILZIIIJWcMF+BCk6vdTMDMbhQXj+VC8y9+To+2Rs2io0FF/X5sHXKShFqjUWZFpvWD2
        2Qan9NrxdGvwUwV47jUecy4SyZZwch4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653296344;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h1QuB3M+BmdTEHvDbJ/48/qLXP8QUk8L4+wxn4b3JqE=;
        b=UTh5pzrrDqKQxilv/HUuRQHZel4jue/bNpbW5iFLK+uFLL6KEgaRovHb4Cq7L/5LXVPIgN
        uIHOwEt7pP/JwFAw==
Content-Disposition: inline
In-Reply-To: <55919e29-1f22-e8aa-f3d2-08c57d9e1c22@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>, paolo.valente@linaro.org, jack@suse.cz, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Mon 23-05-22 09:10:38, yukuai (C) wrote:
> 在 2022/05/21 20:21, Jens Axboe 写道:
> > On 5/21/22 1:22 AM, yukuai (C) wrote:
> > > 在 2022/05/14 17:29, yukuai (C) 写道:
> > > > 在 2022/05/05 9:00, yukuai (C) 写道:
> > > > > Hi, Paolo
> > > > > 
> > > > > Can you take a look at this patchset? It has been quite a long time
> > > > > since we spotted this problem...
> > > > > 
> > > > 
> > > > friendly ping ...
> > > friendly ping ...
> > 
> > I can't speak for Paolo, but I've mentioned before that the majority
> > of your messages end up in my spam. That's still the case, in fact
> > I just marked maybe 10 of them as not spam.
> > 
> > You really need to get this issued sorted out, or you will continue
> > to have patches ignore because folks may simply not see them.
> > 
> Hi,
> 
> Thanks for your notice.
> 
> Is it just me or do you see someone else's messages from *huawei.com
> end up in spam? I tried to seek help from our IT support, however, they
> didn't find anything unusual...

So actually I have noticed that a lot of (valid) email from huawei.com (not
just you) ends up in the spam mailbox. For me direct messages usually pass
(likely matching SPF records for originating mail server save the email
from going to spam) but messages going through mailing lists are flagged as
spam because the emails are missing valid DKIM signature but huawei.com
DMARC config says there should be DKIM signature (even direct messages are
missing DKIM so this does not seem as a mailing list configuration issue).
So this seems as some misconfiguration of the mails on huawei.com side
(likely missing DKIM signing of outgoing email).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
