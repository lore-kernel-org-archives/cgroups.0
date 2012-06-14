From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 4/4] make CFLGS_OFF_SLAB visible for all slabs
Date: Thu, 14 Jun 2012 10:19:55 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1206141019010.32075@router.home>
References: <1339676244-27967-1-git-send-email-glommer@parallels.com> <1339676244-27967-5-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1339689072; bh=pDrSdloCjIaQRDU8QE0NLJHx+GJEZB+MmVGApSJV2wA=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=bc43ENcPr18ScklEhWLIb6CzU0KrnQkf29BJlhDk+xL+DIiMGXZaAijcT+xpDkwKE2WyFhJXOlxrj4FslOH/OUN4fUJIxhs2D2uFl0FwxwxgjDQ8zWPsMY4JmrxyqNbKL15xKbZHHv1VQ308/vzdQXBQeznTWUL7wwMlBKNmzv8=
In-Reply-To: <1339676244-27967-5-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org, devel@openvz.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Thu, 14 Jun 2012, Glauber Costa wrote:

> Since we're now moving towards a unified slab allocator interface,
> make CFLGS_OFF_SLAB visible to all allocators, even though SLAB keeps
> being its only users. Also, make the name consistent with the other
> flags, that start with SLAB_xx.

What is the significance of knowledge about internal slab structures (such
as the CFGLFS_OFF_SLAB) outside of the allocators?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
