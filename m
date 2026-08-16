Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00C13BCD2C
	for <cgroups@vger.kernel.org>; Sun, 16 Aug 2026 19:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786907460; cv=none; b=H+fDK1PhwrA0+HQ+yJ/A38fEdZhCM1QPP655PXjVRou4IGTEKsbk0jirO1xVJDJezFPKUEVtIY8FS14vidyCbTaF9nZtGV/khI1+tIWH743/a5mdkTn2oq2dm5C6zvRp7bf8rnaXQhowtm5Za0OZ5627t7OXuKMrNhuDrTFcL/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786907460; c=relaxed/simple;
	bh=7kyrC75oxk/YMZSPlkcSuxRIjtSfW+EF61T7gQKOti8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WbHfneeZ7VKKFIDinTNfAooN3OaIrxi0UeehtAzVy3gHhTuJHQGC2kof5FYD1sO/uEH387qogUCOcl/ZhpGBFp5Oc4lRXGaQ1WiamaUfXRUpIV1qm7qbKGCUaAXhEHaH3Y9Pdx9zC+fToU+J8UC+xCxbYBsOPmLTlnxs3AwCpWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lk58hIJQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lk58hIJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9AE1F000E9;
	Sun, 16 Aug 2026 19:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786907459;
	bh=65xm/BJ2ILV0+VnpFw5xUmzgOfgFFFEa6yjAp0pX8N0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lk58hIJQhP2tQmKfHOYxDKjHbnzQCpKafIxj92z2lAMUf0yVPjuSdF1GNIZY0YCWr
	 VNLXhZ0E20ngfkXVAG7HLy9KdnzRdkjiWhNJSdgnHou/PcrKv3g/8MUfBUzXFQcgVz
	 oK+/xGIfa9TPn5cBC+N1hfZwlba1YqcGMtcLzfLxzHZq1pXj45OHUDk5O5KSCSriLb
	 UXjsWPdH9jCPZoLVtHznBaBBkzU9JwMN/UIU1XZM6Y4rQmSegEd6N7IS+Kq2Xxfv51
	 bonXk2oiqHc+O59K8bonyUk3zxTo1JPSddtknK60zuyPKNqacYEHxC7hS6CVqYbiDQ
	 15zDN/ITjZExQ==
Date: Sun, 16 Aug 2026 09:10:58 -1000
From: Tejun Heo <tj@kernel.org>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
Cc: maarten.lankhorst@linux.intel.com, intel-xe@lists.freedesktop.org,
	cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org,
	pallavi.mishra@intel.com
Subject: Re: [RFC] dmisc cgroups controller
Message-ID: <aoILQuck_EuxQgVh@slm.duckdns.org>
References: <894f9d44eae62aee5762495b4f90f9bdd2b5585d.camel@linux.intel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <894f9d44eae62aee5762495b4f90f9bdd2b5585d.camel@linux.intel.com>

On Fri, Aug 14, 2026 at 11:32:54AM +0200, Thomas Hellström wrote:
> Hi!
> 
> We (drm/xe GPU driver) have a use-case where we have a very limited
> number of a particular device resource (CLOS slots) that we potentially
> want to expose to unprivlieged processes for reservation / allocation.
> We want to be able to restrict per cgroups the number of CLOS slots
> that are available for reservation / allocation.
> 
> This is not a good fit for the misc controller since these resource
> types may be added and removed similar to dmem regions. Neither is it a
> good fit for the dmem controller.
> 
> Would a dmisc controller be suitable here? It would be similar to the
> misc countroller but with dynamic addition and removal of resource
> types similar to the dmem controller.
> 
> Any input greatly appreciated.

Would extending the existing misc controller be an option?

Thanks.

-- 
tejun
