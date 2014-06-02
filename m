From: David Rientjes <rientjes@google.com>
Subject: Re: [patch] mm, memcg: periodically schedule when emptying page
 list
Date: Mon, 2 Jun 2014 16:48:46 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1406021648260.8495@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406021612550.6487@chino.kir.corp.google.com> <alpine.LSU.2.11.1406021637170.5627@eggly.anvils>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=kBGqm0TYNCa+PcfI9ZiCjKlvjp6yp3cn2sXLY/63VfE=;
        b=E+WD6RY9z7XrF9ABV1DxcdhOa2wjJc6GzBpXTPu8yfXl7IyKfdx/NuisVvyMohv6Th
         VtN2sbhn4nWIcK16zQ/D2wSoazrx3VikUoUdY2/jdPTJSiUbG2CHiZsVJV7v5Xn9S0qj
         Abq2mji8tzCLniy0NL/+1d9F7JQBjCmrVUx3kZrAA4U57Ft3OCo9y5I8TfXYi/saSTDf
         vX4OfIkjEDK5EoMGq2EimDEXseQwun/vM01aCxfHBplrEfR4ypmWeEysZvQg871t34i8
         QuKKrdN/IJ5TkKbzK2h/+L5WMFSXQeBR0qg8RBEa0FoPTEVmSQuWT9Lvo56vUW4XrCyq
         KbWQ==
In-Reply-To: <alpine.LSU.2.11.1406021637170.5627@eggly.anvils>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Mon, 2 Jun 2014, Hugh Dickins wrote:

> Why not just move that cond_resched() down below the if/else?
> No need to test need_resched() separately, and this page is not busy.
> 

Would you like to propose your version from our kernel instead?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
