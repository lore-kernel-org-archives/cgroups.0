From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [Bug] race condition at rebind_subsystems()
Date: Tue, 19 Jul 2022 15:35:12 +0200
Message-ID: <20220719133512.GD897@blackbody.suse.cz>
References: <1978e209e71905d89651e61abd07285912d412a1.camel@mediatek.com>
 <20220715115938.GA8646@blackbody.suse.cz>
 <YtGaP+e35DZYSQf0@slm.duckdns.org>
 <d8f0bc5e2fb6ed259f9334c83279b4c011283c41.camel@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:In-Reply-To:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=NcWyiLSSUtWiT6QYkEaCFiw6z8iTfe7BuCTgI38McPA=; b=pbGPS4VcjPaGmI
	/IGl9u4KJWHJ7Qt7mE6D3qakRt9sj3h5iWjxaM1rjslL+u9YnQiy3uBadpBKyE53iC6ui9oyqOovW
	NsTWGSWBj+M9tSl5g1s5bLyo3SFGfxFtQQAEtAuZPD7Xp0ieIIoW8dR3EjubBFhS1dJm8d5CArxD1
	mjqTCdbcFf0Qb6m3y1BDru8+ZErugezycmOv8tXbhtf97+OA6VaCEbEadYCWJ/NIYqsiZFVK55Ce+
	l0PhRZzTBRk1khwVD+DPuDu+VfSvLq6zCQ9TbdCbvPRh73zl1eo0Fjm0z6qKLj/W2GTlfvcB/5c/0
	RNNs7i5GnCVNRc+2GjyQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1658237713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dQkGZ2bUCaXoPh/D/Jj4IPkCDd93zpdb0jFOJ4x+L1k=;
	b=RXpYSGlmRcef3l7YiwRFdAApPwXNCGsn0BDGq8RMYOlXFurF0+ck6ho6rGcVbsWtc/fUP6
	De4sOP94LDSs7rGW7/DXiKXGZ3iMCVaCS8xrKMTqCvGXTFpvP8npNoI8fDTvetmmD0jubo
	mc2b6WY+Bg2Qby9yeLCG9cnhEe+PPKo=
Content-Disposition: inline
In-Reply-To: <d8f0bc5e2fb6ed259f9334c83279b4c011283c41.camel@mediatek.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane-mx.org@lists.infradead.org
To: Jing-Ting Wu <jing-ting.wu@mediatek.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Matthias Brugger <matthias.bgg@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Shakeel Butt <shakeelb@google.com>, wsd_upstream@mediatek.com, lixiong.liu@mediatek.com, wenju.xu@mediatek.com, jonathan.jmchen@mediatek.com

On Mon, Jul 18, 2022 at 03:44:21PM +0800, Jing-Ting Wu <jing-ting.wu@mediatek.com> wrote:
> Accroding your description, is the following patch corrent?

Yes, this is what I meant (i.e. grace period before invalidating the
removed rstat_css_node).

> If the patch is correct, we will add this patch to our stability test.
> And we will continue to observe whether the problem is solved.

It'd be great to have such confirmation.

Thanks,
Michal
