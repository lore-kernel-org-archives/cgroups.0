From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Use after free with BFQ and cgroups
Date: Thu, 23 Dec 2021 18:13:45 +0100
Message-ID: <20211223171345.GE19129@quack2.suse.cz>
References: <20211125172809.GC19572@quack2.suse.cz>
 <20211126144724.GA31093@blackbody.suse.cz>
 <20211129171115.GC29512@quack2.suse.cz>
 <f03b2b1c-808a-c657-327d-03165b988e7d@huawei.com>
 <20211222152103.GF685@quack2.suse.cz>
 <d770663a-911c-c9c1-1185-558634f4c738@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640279628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TK8w/l2QmkKbweJf4VP5hkqJcVEfLR6+7DArEF8svg0=;
        b=N3/Mg4U+xanWLS7bAaYDZP3g6btzRSuYvsvFl8fzz3i/KoD0mzhP2WkozLnYEXg7pAYEcL
        7aZqzXk5T/hOrNJpK83n2KFLjdJYNcdM6OyxH6/i40b0Rrmcwyo8mJ1Sed6xjKpip4/MmU
        30TjoOc1SpPAloZxkLpf6Q8a8FnMLa8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640279628;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TK8w/l2QmkKbweJf4VP5hkqJcVEfLR6+7DArEF8svg0=;
        b=fZsVIT/8nYiFKohB3PYI+Tz1zhjd13tVgKSwUm+zfPngwa8hyJelVLscYzOYaxhslRz9Z4
        HQOjiTluRe2hvyAQ==
Content-Disposition: inline
In-Reply-To: <d770663a-911c-c9c1-1185-558634f4c738-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fvogt-l3A5Bk7waGM@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 23-12-21 09:02:55, yukuai (C) wrote:
> 在 2021/12/22 23:21, Jan Kara 写道:
> > On Thu 09-12-21 10:23:33, yukuai (C) wrote:
> > > We confirmed this by our reproducer through a simple patch:
> > > stop merging bfq_queues if their parents are different.
> > 
> > Can you please share your reproducer? I have prepared some patches which
> > I'd like to verify before posting... Thanks!
> 
> Hi,
> 
> Here is the reproducer, usually the problem will come up within an
> hour.

Thanks! For some reason the reproducer does not trigger the KASAN warning
for me (with or without my patches). But anyway, I'll post my fixes and
we'll see what do people think, also I'd be grateful if you can test them
in your environment. Thanks.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
