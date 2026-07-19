Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBB61ADFE4;
	Sun, 19 Jul 2026 05:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784438796; cv=none; b=IUFgWgHIeSDzn85amJT27RgBRqN33DgB9Jfx4xAyfAXoce1HED1IMtjr01f9fTu1LIL4PAriKth6JvrM9vY98DulJSEQKhypwHvQ8kK9RzgIAzMNGEcnue/GJ5lCl7aMjgljf6A+Nl6q7qhjI/MsFI6WltVxba/2KbogC3jelwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784438796; c=relaxed/simple;
	bh=Hi0xnivGNtOREXt/UYVZ9Q6LdSO1ZOzCw7BzXniVlWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBbCqLmbVg5+IwXvfpjhZNZF3CQV9J7zq8ib4tKWDp7/oi0MeiZ4WbmkeMSV0XzGdZgWoFGILgjOIr46i+aLNytm+ap47wyLU+fsaRLgC0qBxQoI3y48cH3GlDQETYSMIsRr03RJaEp0n9LQQjgdyHDLArzjQxn65xI62qyvnXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=wF3Z0gGe; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=AKArMgXA; arc=none smtp.client-ip=103.168.172.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="wF3Z0gGe";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="AKArMgXA"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.phl.internal (Postfix) with ESMTP id CE29B1380039;
	Sun, 19 Jul 2026 01:26:32 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Sun, 19 Jul 2026 01:26:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1784438792; x=1784445992; bh=eecg0lJ7GM
	VPKq2dqzJPtaANo6Zq9o9SX4g1WVGOqPE=; b=wF3Z0gGeJCJaKfT2Xzm96MtuXe
	6i9JuofDLJjag12vbKOQXxWUwCIDLG5qLYIs3jssGixw1ydxbSLbcUhEk3RYJ32q
	p6jfDXze08QvqdxVdwl8rKjDASgJSXvLRwZ62jiWu9f4H2yYQmbl4WiOV2SWP1Vx
	Ik8k2RBZOD3tdyhzUwg54aK8Sz9RMx2s127/iyv+7czqc/6+tcichKZSP1OZcPhP
	0JZTTAWjf2TJn4ZrSgA0w0oQ6PCyE2omuPGsJPi0Z9Qmbb7Skdxhf/UNxqgyiXfw
	jOJV6HVK+yhxgvIB2f3TKVK5WDLsMybEliLYF/TVypMNiOA5ZcrVFyk3eaHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784438792; x=1784445992; bh=eecg0lJ7GMVPKq2dqzJPtaANo6Zq9o9SX4g
	1WVGOqPE=; b=AKArMgXA3oyEOmb2gYEzdRDbrk3jjIXGftrclIsUb78ZrPV9v5Y
	2wcdLr1a/HOaopYJT2+xCMrXY7TMhrWHKmmp9/O1JVFCGtf1rdGVnOcpBVr8GQ28
	hZ2Alpm2IEd7aSqo9PYD8mB3rh+G06RNMuoMG37xZqndPFspDxPTk0pnLQjHwtWt
	klhTddiY9LhSZQbwBKTNyJOoCMv5EZcSfRjnfZXML/fGUGUEl0ZKu3UEGvyRoCNY
	zHzI1uHYDh5yM7Nuh7ZCUZZCXs3+Qpynt4yP0+ToCTobJs94R1DSgA+HPqzaQhq9
	jfE9BXC3zH145AcWFjp4PbGuSoepK6See2w==
X-ME-Sender: <xms:CGBcam68ZHdmeOZ6tIQlFEKIdnwi1LM-SnuyPCsXOD78ThhloUfBTg>
    <xme:CGBcanZmjiiooxYRu3pPUxpTWWn2AC0VxmPy-z3w490VEBZa84t5T_4cbahE8lezm
    2I_TG77RStcZ3L79G_YeSCAxCvZpMD7_0HT7JDWxAt5SSfi-jE>
X-ME-Received: <xmr:CGBcari6G4fr-bl4jC8-Td5rz8WjiZeWAmxbr3eJ--9PxS8mf55FfOnhyl6TFiEDiGhsjY4lioPkyNPLOTd233x_mA>
X-ME-Proxy-Cause: dmFkZTFQyx31AWctr4aPvIzgtsidowCfviJ8Nq9RswvKEgWVIwvPHJ7EsYxWWMbjEFho7t
    eR6zYIF+VcSNrTn/hg7VWB4uXEoAtwAzRf6c4Ux22xnFlnsswmCcO4dlsWLwit5cClU4lN
    ECYl22j0epkDLpuABXzsKZmVYFeVuGQNlUPZPQmox1CQczKo6hSKFRmzaGpYxfNbs4BuAz
    sv02VwwRup0SOCrcdLWmNwYGQIYSLiyJK5d7ilLs1rnPYKAnUdKHQ94+NCoqajlgyQ4XaD
    aSvdTZeqskrLNrMmTmB9V80ytqPmuABDEHqWwfBGM3fYPxDplDwLNr3zg0bhul+bQOQjas
    qV1G65lemm+JDmE4s94CT9c6EqdzXXwbftihLrVEI48kR5H1ahDB5w1sda33uxSKTkgNb/
    8hb9jkSCAcAvLcLjQ+JEimezd3xBXPeZ/DHhmaGni/WJwJxHWI7cek23NEfyYp3RfrM872
    Rmu+1pGFAFqcRsei+p+coRVDg4BPsUIOYEjsy7H/7kooso6XSi8eI6RwI9mrMc4VypYbO2
    0R1JKagCw784hviQbYjNQ1kWTn/Njvg9X4JKynXiZsg8ypnlAjElr8koDDlcjoL+FrlePi
    GObYuv5KGYMs65AWOwyjfBrvY6WPigO+wScHTOGsS6llmAhvm0vWbft3EWDA
X-ME-Proxy: <xmx:CGBcahPa4HHXOK2-dWQGSAHgyS0kySTOlNx-M6lUq9lILtWlkbt97w>
    <xmx:CGBcalPN2wFfvbIMC7-ekhGkcvvqpK73TSwuTd8mEJniJ8LG7doEwA>
    <xmx:CGBcapJRtsQE8OHwhupEvfihfRzgTlb5TGQeXj_-3oqgVpadbrSpJw>
    <xmx:CGBcakvRPEJGOgtk4HVpP1ynJCb7FxkI5EvuzJsllO7IgPXVJy02WA>
    <xmx:CGBcapoJ6eTL5egjSNblq9BuInL0vu4lryGfgmHfPvOx7uAJrI_RmC1w>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 19 Jul 2026 01:26:31 -0400 (EDT)
Date: Sun, 19 Jul 2026 07:26:24 +0200
From: Greg KH <greg@kroah.com>
To: Yahya Toubali <yahya@yahyatoubali.me>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:DOCUMENTATION PROCESS" <workflows@vger.kernel.org>,
	"open list:SOUND" <linux-sound@vger.kernel.org>
Subject: Re: [PATCH v3] Documentation: add SPDX license identifiers to RST
 files
Message-ID: <2026071910-repressed-elsewhere-e2f8@gregkh>
References: <20260718165618.1923627-1-yahya@yahyatoubali.me>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718165618.1923627-1-yahya@yahyatoubali.me>

On Sat, Jul 18, 2026 at 05:56:16PM +0100, Yahya Toubali wrote:
> Add SPDX-License-Identifier: GPL-2.0 to RST documentation files
> that were missing it. This aligns with kernel documentation
> conventions.
> 
> Signed-off-by: Yahya Toubali <yahya@yahyatoubali.me>
> ---
>  Documentation/admin-guide/cgroup-v2.rst      | 1 +
>  Documentation/core-api/housekeeping.rst      | 2 ++
>  Documentation/core-api/memory-allocation.rst | 1 +
>  Documentation/doc-guide/sphinx.rst           | 1 +
>  Documentation/process/5.Posting.rst          | 1 +
>  Documentation/process/howto.rst              | 1 +
>  Documentation/sound/designs/index.rst        | 2 ++
>  7 files changed, 9 insertions(+)

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/process/submitting-patches.rst for what
  needs to be done here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
