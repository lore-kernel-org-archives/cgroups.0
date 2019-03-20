From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v6 2/7] psi: make psi_enable static
Date: Wed, 20 Mar 2019 16:55:17 -0400
Message-ID: <20190320205517.GA19382@cmpxchg.org>
References: <20190319235619.260832-1-surenb@google.com>
 <20190319235619.260832-3-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QQYLVXkrs82mdvyVr+o8qJgCSfJ2t/bxI7yFaYhe2ug=;
        b=UlM3Ag0sHjKm6b60Xzruo36+UDlJMrcULXCsz153tfTpIzb5RNHWobPLHgqI/mhWmy
         nAzG2b60WzKXMmT44qvypKs/MRK3dAvTvsH7FaGR2TvLZdw4/xJW8HsjT5RsKvT2l114
         IxT/BWtMIDwxGR3Rmfw37IsijmQCBbzByTYNMnfL5Pqrmqbt0ycHo6hbZZnw/ciMk73x
         cPcXJLfScHgpDqcmjbfZuTV1rp0MyTLNKhI28W8pS3bGyOp6RhItnuEcuUJOy2Kdykwv
         PxWIWOxISeF3vhf5selrKImaCqn1ve35lBZip8IjabpLC+gzrspIs30WY8hjdR6M7M8X
         2FsA==
Content-Disposition: inline
In-Reply-To: <20190319235619.260832-3-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Tue, Mar 19, 2019 at 04:56:14PM -0700, Suren Baghdasaryan wrote:
> psi_enable is not used outside of psi.c, make it static.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
