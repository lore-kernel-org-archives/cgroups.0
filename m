From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH 3/3] make 'none' field a flag
Date: Sun, 11 Dec 2011 13:59:25 -0500
Message-ID: <4EE4FD8D.4020704@gmail.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-5-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=XeqdmWxrD3FM8I68/UuWIGpLVMpTP/yj8eNaH73qf98=;
        b=Xv9jrL3tPxwJpTcoARW85coToO1wZWgHGtzQP5Ebh/zIHXYL0R5HPlNkFLwVXP6O7O
         qFr//TMIExI9j6VMXKDrKruc1I189ZEEQ9HF3ZiBNl1JAga09RbOeIyOyFfS2h+R+Jku
         qwZnHS3srEzcttspsB+16P+WV2MC5E7Pi8sD4=
In-Reply-To: <1323614738-7405-5-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, jbottomley@parallels.com, cgroups@vger.kernel.org, bsingharora@gmail.com, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org

(12/11/11 9:45 AM), Glauber Costa wrote:
> There is no reason to have a flags field, and then a separate
> bool field just to indicate if 'none' subsystem were explicitly
> requested.
> 
> Make it a flag
> 
> Signed-off-by: Glauber Costa<glommer@parallels.com>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


