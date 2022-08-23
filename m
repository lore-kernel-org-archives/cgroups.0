From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/1] cgroup: Fix race condition at rebind_subsystems()
Date: Tue, 23 Aug 2022 08:12:12 -1000
Message-ID: <YwUYfNEVIOyQXP8d@slm.duckdns.org>
References: <20220823054148.29346-1-Jing-Ting.Wu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:In-Reply-To:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=l0/EScO7kujkYsls11sRO6TFRpnYi8csTbsNB3b3YWQ=; b=SrM8mtdguT0RB9
	etCutU+oNH3FRu7BRNA1s+eNPlOLw7TekIDRLVrnH16cCMsQ8rmOLUd27j8lbKcNJCMyYowuYRFH9
	1fMHQ7mdBHhlMlMTYtKel0UbfbbDjNVw3N4sUGwupJODFAdfk56rWP6R2aRKuv1i+hw0qRkX125hG
	hjp69l1N6h0kAY2Uyi7lkC36I1x3MfwErkPC+0DEk9vE3C+fA3Hy9zpbSOPbtKawJJIDUDppt0KLO
	A7VhkBaC6G2shpzwezTBCPxVLVO3c6wh9Z55MYtrydYTtVpkWrteWd+e++7q7yLR70epfxFnupD27
	eFmB3JEtCbvehcs5ZbwA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=w6Y6IjnB/7GXBq23acV5syGhC64cBXwxU4OuyhZd8CQ=;
        b=IaP7cFBpGcNi3/hhyxFebsnvxJsMy54QTl7EkiYLgJCebOU1/sY6ya+8Jj7s9gc5zJ
         m96Jd0oUB9ii7t+kjHWa0AYbqnMm5HXw9j51y4fR0GTSjpmruV6mcpR1pH2bNOo7Eh9J
         1+m93Urk2CcVD+dQQvvEOgbAJqBAErrzKbUqYPqCFKfnC9JQXmYBIYNVyoJZVAbB6LO2
         5fvVxUuzhxJTX2ZCcqC78LL+jJzs7uc6dP6iwGIMRwK76xIIh3W8VDmSaT8p0QyXPYzZ
         WxnHrnIHJWsGCnNde81/z4kR2sB4563gvDfugD+mJi4dvRasMOT9T+3eMQq+GiKhQ+Kp
         xOkA==
Content-Disposition: inline
In-Reply-To: <20220823054148.29346-1-Jing-Ting.Wu@mediatek.com>
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
To: Jing-Ting Wu <Jing-Ting.Wu@mediatek.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthias Brugger <matthias.bgg@gmail.com>, Jonathan.JMChen@mediatek.com, Lixiong.Liu@mediatek.com, wsd_upstream@mediatek.com, Wenju.Xu@mediatek.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org

On Tue, Aug 23, 2022 at 01:41:46PM +0800, Jing-Ting Wu wrote:
> Root cause:
> The rebind_subsystems() is no lock held when move css object from A
> list to B list,then let B's head be treated as css node at
> list_for_each_entry_rcu().
> =

> Solution:
> Add grace period before invalidating the removed rstat_css_node.
> =

> Reported-by: Jing-Ting Wu <jing-ting.wu@mediatek.com>
> Suggested-by: Michal Koutn=FD <mkoutny@suse.com>
> Signed-off-by: Jing-Ting Wu <jing-ting.wu@mediatek.com>
> Tested-by: Jing-Ting Wu <jing-ting.wu@mediatek.com>
> Link: https://lore.kernel.org/linux-arm-kernel/d8f0bc5e2fb6ed259f9334c832=
79b4c011283c41.camel@mediatek.com/T/

Applied to cgroup/for-6.0-fixes w/ stable tag added.

Thanks.

-- =

tejun
