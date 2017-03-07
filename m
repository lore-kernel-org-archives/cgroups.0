From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 12/19] kernel: convert css_set.refcount from atomic_t to
 refcount_t
Date: Tue, 7 Mar 2017 19:12:51 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C55AD8@IRSMSX102.ger.corp.intel.com>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
 <1487585948-6401-13-git-send-email-elena.reshetova@intel.com>
 <20170306195439.GD19696@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170306195439.GD19696@htj.duckdns.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-audit@redhat.com" <linux-audit@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "mingo@redhat.com" <mingo@redhat.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "acme@kernel.org" <acme@kernel.org>, "alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>, "paul@paul-moore.com" <paul@paul-moore.com>, "eparis@redhat.com" <eparis@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

> Hello,
> 
> On Mon, Feb 20, 2017 at 12:19:01PM +0200, Elena Reshetova wrote:
> > @@ -134,10 +135,13 @@ static inline void put_css_set(struct css_set *cset)
> >  	 * can see it. Similar to atomic_dec_and_lock(), but for an
> >  	 * rwlock
> >  	 */
> > -	if (atomic_add_unless(&cset->refcount, -1, 1))
> > +	spin_lock_irqsave(&css_set_lock, flags);
> > +	if (refcount_read(&cset->refcount) != 1) {
> > +		WARN_ON(refcount_dec_and_test(&cset-
> >refcount));
> > +		spin_unlock_irqrestore(&css_set_lock, flags);
> >  		return;
> > +	}
> 
> This isn't an equivalent conversion and should have been mentioned in
> the patch description.  Hmm... and I'm not sure this is a good idea.
> Can't we add the matching operation on refcount_t rather than adding
> extra locking like this?

Oh, actually this is fault on our side: initially we didn't have a refcount_dec_not_one() interface and we had to be creative in converting cases like this, but now the interface is present, but we actually forgot to convert this particular case. 
So, the above change should be:

-	if (atomic_add_unless(&cset->refcount, -1, 1))
+	if (refcount_dec_not_one(&cset->refcount))


Do you want me to resend or could you modify the patch while applying?

Best Regards,
Elena.

> 
> Thanks.
> 
> --
> tejun
