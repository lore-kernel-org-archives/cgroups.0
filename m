From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
Date: Thu, 2 Feb 2023 10:33:17 -0800
Message-ID: <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <875yckvt1b.fsf@meer.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675362835;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X89YYZa5QwwoFoyVa+cjqv3j8qodot1iuTODrRYZyJE=;
	b=bUPDWklZHlTE1fxd0Nwv54+ymXoIRMfKdCfhvR9IMSe3QEwLveSX7TM6+xHokm30beZqFM
	dn1rDjnmrRVf5258UXU8955TrWMoVJE0AsaIe5OpjfrOYgKikpUmVsTK/UUfG6/EZjWX9q
	t/fVhI/L8NSYIfiD4hwnQcpI7c4d3ug=
In-Reply-To: <875yckvt1b.fsf@meer.lwn.net>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
Content-Language: en-US
To: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, linux-doc@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com, netdev@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, sparclinux@vger.kernel.org, Neeraj Upadhyay <quic_neeraju@quicinc.com>, Alasdair Kergon <agk@redhat.com>, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Guenter Roeck <linux@roeck-us.net>, linux-media@vger.kernel.org, Jean Delvare <jdelvare@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, Mike Snitzer <snitzer@kernel.org>, Josh Triplett <josh@joshtriplett.org>, linux-raid@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jiri Pirko <jiri@nvidia.com>, cgroups@vger.kernel.org, Dan Williams <dan.j.williams@intel.>



On 2/2/23 10:09, Jonathan Corbet wrote:
> Randy Dunlap <rdunlap@infradead.org> writes:
> 
>> Maintainers of specific kernel subsystems are only Cc-ed on their
>> respective patches, not the entire series. [if all goes well]
>>
>> These patches are based on linux-next-20230127.
> 
> So I've applied a bunch of these
> 

>>  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>>  [PATCH 7/9] Documentation: scsi: correct spelling
> 
> I've left these for the SCSI folks for now.  Do we *really* want to be
> fixing spelling in ChangeLog files from almost 20 years ago?

That's why I made it a separate patch -- so the SCSI folks can decide that...

-- 
~Randy
