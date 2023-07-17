From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/2] eventfd: simplify signal helpers
Date: Mon, 17 Jul 2023 19:12:16 -0300
Message-ID: <ZLW8wEzkhBxd0O0L@ziepe.ca>
References: <20230630155936.3015595-1-jaz@semihalf.com>
 <20230714-gauner-unsolidarisch-fc51f96c61e8@brauner>
 <CAH76GKPF4BjJLrzLBW8k12ATaAGADeMYc2NQ9+j0KgRa0pomUw@mail.gmail.com>
 <20230717130831.0f18381a.alex.williamson@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-aio@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1689631939; x=1692223939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nfZGdLayIsQ4EXLbarw1/OO0pNLBzQdwR1vEqsrzGII=;
        b=Jk8Ffu+zgnI1CsgL7PShvnMc/G0hm1hbh3TPz5Fbc34BI/VC6K+YvpO0Dtz1Q06LcE
         vf29m9vckcSQeAqUEVUy2hQg3wChzTMiZjPdUNSWsPB40TqlA/Z3Z90RDeI/5eGEIh5a
         oHIWxzri1XJMuhuB2UIvkNGwKQM8BtpRM8RbCOHyQCc7eetsY5S+VbcO2iAUIljyLIvn
         7DgUtRFxxg3tnphZnCaerMskJ/OIgXT3e8pOBne6YWSI+yYb8YG43ww6ejPC+GReMaLK
         AQZU6DLVDF3nw8hq4CMA6FGa2JzmC2rObjfL+xz46TVHFpF838cUJw0/Qyn0hTY2P629
         8fnA==
Content-Disposition: inline
In-Reply-To: <20230717130831.0f18381a.alex.williamson@redhat.com>
Sender: owner-linux-aio@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Grzegorz Jaszczyk <jaz@semihalf.com>, Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-usb@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>, Paul Durrant <paul@xen.org>, Tom Rix <trix@redhat.com>, Jason Wang <jasowang@redhat.com>, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Kirti Wankhede <kwankhede@nvidia.com>, Paolo Bonzini <pbonzini@redhat.com>, Jens Axboe <axboe@kernel.dk>, Vineeth Vijayan <vneethv@linux.ibm.com>, Diana Craciun <diana.craciun@oss.nxp.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shakeel Butt <shakeelb@google.com>, Vasily Gorbik <gor@linux.ibm.com>, Leon Romanovsky <leon@kernel.org>, Harald Freudenberger <freude@linux.ibm.com>, Fei Li <fei1.li@intel.com>, x86@kernel.org, Roman Gushchin <roman.gushchin@lin>

On Mon, Jul 17, 2023 at 01:08:31PM -0600, Alex Williamson wrote:

> What would that mechanism be?  We've been iterating on getting the
> serialization and buffering correct, but I don't know of another means
> that combines the notification with a value, so we'd likely end up with
> an eventfd only for notification and a separate ring buffer for
> notification values.

All FDs do this. You just have to make a FD with custom
file_operations that does what this wants. The uAPI shouldn't be able
to tell if the FD is backing it with an eventfd or otherwise. Have the
kernel return the FD instead of accepting it. Follow the basic design
of eg mlx5vf_save_fops

Jason

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
