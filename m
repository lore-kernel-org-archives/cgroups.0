Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B1E3A63FB
	for <cgroups@vger.kernel.org>; Fri, 26 Jun 2026 20:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782505174; cv=none; b=BIm6dzeXQQOOUT+OZlew7SwjOAx9GpXi74Hjq/DQjJwP+QPRUMNxxxVdijVhqWTaQmWYOqZskFYRSHlj/ai+BK/1CqLz4/0y/ZkwsDirD4McYJC3NJjQMSiLIkqTZ9e26mvbc66p2zCQWWzICXk4Ze6I3ZkX7nbeeyY/xYW8alQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782505174; c=relaxed/simple;
	bh=SvCnu2Q5W9nMA9SSs3kS9DQruc5S26eBF1M5NEEytkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GO11rrCxQAog4YmankAEhMAD1gjXjxsGnpPqcKuaMOYtTyfVvsQaYRzHoUrUGuJ9yKO7g6G+2o4f6aUeFtjIftx747n2RqSiqcVIB1c7VZ4sfGOAYyGeJh1uHql5UmqlDBte4zMVZWuP321RuVm0bIgwLCvkTZYzB0Qpt3WLYvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bDRiUHsY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bDRiUHsY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782505172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DRAoRR6aNWHMFDorHMUqC0wG77MmrRwnzU9CV7RfZA0=;
	b=bDRiUHsYWOcgy5h+ZLNyR2fEJgIY6sIh9q7B9ZESIu8eMliNFZGl522q0kVX+MYnnMGoev
	KfVjUV9I7+nWL4z9EHuStiYSj4JwuoqTKXgcvz+f2OzTX7Er4AkIJMN+/ncXG5Gt2duyUN
	2oSzPyb1ZLA2MExId/XaONZbKECXBrQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-636-UK0yQW1INC2fCfkRSTPNhQ-1; Fri,
 26 Jun 2026 16:19:31 -0400
X-MC-Unique: UK0yQW1INC2fCfkRSTPNhQ-1
X-Mimecast-MFC-AGG-ID: UK0yQW1INC2fCfkRSTPNhQ_1782505169
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83A221800A36;
	Fri, 26 Jun 2026 20:19:28 +0000 (UTC)
Received: from oak (unknown [10.22.88.172])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 530FA1956095;
	Fri, 26 Jun 2026 20:19:25 +0000 (UTC)
Date: Fri, 26 Jun 2026 16:19:18 -0400
From: Joe Simmons-Talbott <josimmon@redhat.com>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Joe Simmons-Talbott <joest@redhat.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>,
	cui.tao@linux.dev, Li Wang <li.wang@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v4] selftests/cgroup: Adjust cpu test duration
 based on HZ
Message-ID: <20260626201918.GC19617@oak>
References: <20260625203307.1114538-1-joest@redhat.com>
 <aj6r_tUrPH8eTuQw@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aj6r_tUrPH8eTuQw@localhost.localdomain>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Jun 26, 2026 at 06:44:46PM +0200, Michal Koutný wrote:
> On Thu, Jun 25, 2026 at 04:33:04PM -0400, Joe Simmons-Talbott <joest@redhat.com> wrote:
> >  static int test_cpucg_max_nested(const char *root)
> >  {
> >  	int ret = KSFT_FAIL;
> > +	long hz = get_config_hz();
> >  	long quota_usec = 1000;
> >  	long default_period_usec = 100000; /* cpu.max's default period */
> >  	long duration_seconds = 1;
> >  
> > -	long duration_usec = duration_seconds * USEC_PER_SEC;
> > +	long duration_usec, duration_sec, duration_nsec;
> >  	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
> >  	char *parent, *child;
> >  	char quota_buf[32];
> >  
> > +	duration_usec = duration_seconds * USEC_PER_SEC * 1000 / hz;
> > +	duration_sec = duration_usec / USEC_PER_SEC;
> > +	duration_nsec = duration_usec % USEC_PER_SEC * NSEC_PER_USEC;
> 
> Oh, that's duration in so many units and the seconds is there twice. (I
> understand why you did that for the rescale but) could you pick more
> descriptive/distinctive names then and ideally keep it simple :-p

Thanks for the feedback.  I'll send a v5 with those intermediate
variables removed and do the calculatons where they are used to setup
the cpu hog's time values.

Thanks,
Joe

