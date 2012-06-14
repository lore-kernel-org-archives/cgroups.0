From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 4/4] make CFLGS_OFF_SLAB visible for all slabs
Date: Thu, 14 Jun 2012 12:29:02 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1206141228230.12773@router.home>
References: <1339676244-27967-1-git-send-email-glommer@parallels.com> <1339676244-27967-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206141019010.32075@router.home> <4FDA0ADB.2010508@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1339694945; bh=l00b1MraFGtJ6zElVCvHfHQj3ZXcFSTCbGtjTvFvJn0=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=gQ6lUAHNxTt8nAOMpI9MaDIr/ccNnK2c8SPI0JVuHN7q/zt1jcZVPycMuoxriHdblosOC5u5fGf9B06A1kvfvbYrsXBH49TESdje6QULuDw26kdtJF+lL2SXSDB0yj8DzP6pRrjhorZLv1w3WpNZ33zdCmdE0VF1ZuMowQKaYPc=
In-Reply-To: <4FDA0ADB.2010508@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org, devel@openvz.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Thu, 14 Jun 2012, Glauber Costa wrote:

> I want to mask that out in kmem-specific slab creation. Since I am copying the
> original flags, and that flag is embedded in the slab saved flags, it will be
> carried to the new slab if I don't mask it out.

I thought you intercepted slab creation? You can copy the flags at that
point.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
