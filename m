From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2] slab+slob: dup name string
Date: Tue, 22 May 2012 08:58:08 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205220857380.17600@router.home>
References: <1337680298-11929-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1337695091; bh=kjxthTrouvlFbyjqLXci0sXpHF0vmvW9o91g4r3UD7Q=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=fKeyJlZZ8AB8gfDaLe42Ok+A0EhhFlwB0VZ/P41odrJ0597DyTltlDYQ+dXku3vesveMOZVe7j1HGr5zyD057McARthOdxPKiLR1feoQu4F5J9Sn0cEdKcn4UAlqSVSZ9mzgljGZ6BvJod6dkCnPt2IFoqYAQ/tCD7igr5qOdMA=
In-Reply-To: <1337680298-11929-1-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>, David Rientjes <rientjes@google.com>

On Tue, 22 May 2012, Glauber Costa wrote:

> [ v2: Also dup string for early caches, requested by David Rientjes ]

kstrdups that early could cause additional issues. Its better to leave
things as they were.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
