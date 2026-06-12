Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447F838C2A0;
	Fri, 12 Jun 2026 05:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781240999; cv=none; b=kgce8bjAjPuYo7r/FjFHWK/WB2JOxs+xRwLxARST/9iLS+r9PBavvSYCjPNLwS504cZiJGuIt/YCCctEJjt2CvsJVdKLZckYbNReRRrqsUZYmSRnhoU+4nupQoPGXgXvqmeSoFjzkEcxYlwhIdHGAemdXYjWmViP6/eze3aJdhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781240999; c=relaxed/simple;
	bh=sJ9mGuDBF51iJQl66AOPfs77n4Wa4tXYXGQQduefnAg=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=pj9ZFLKxhIVCtPszKNtV7zpoVZZKLUayyVbykn9nWdnctYmm0guES2wWtEWbxuUNcM42Gkz3ehmVityn2/FhZ9hon90YLt/edCb/+jnkZGsJMULe4S+tnLnHQfK9Mnkqbt8sv2hcKF0sLkrQgvj/mQe3P+nI9C+YkKKVLwOFSkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ef+nsQ/X; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ef+nsQ/X"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sJ9mGuDBF51iJQl66AOPfs77n4Wa4tXYXGQQduefnAg=;
	b=ef+nsQ/XrcfexLUEHiICyPLwQk+xnqc9nwUMTJjMozeIHx0AM6piZSgmen1h+o6J93E9ZYv7D
	8oUU5WfLkIYm8BtLqpT/1Tf9/KH9I6r/FbixiKbkZ2Za1rSy2ue++uIoYKPXNsLfXvfu382hBqP
	BCJrtnM7SnhC2Z0nIJvouUA=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gc6nK66PXzLlSD;
	Fri, 12 Jun 2026 13:01:57 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id CAE3840538;
	Fri, 12 Jun 2026 13:09:52 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 12 Jun 2026 13:09:51 +0800
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
To: Gregory Price <gourry@gourry.net>
CC: <lsf-pc@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-trace-kernel@vger.kernel.org>, <damon@lists.linux.dev>,
	<kernel-team@meta.com>, <guanhao.wang@huawei.com>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat> <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat> <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat> <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
 <ainFROZ3WrGioyuY@gourry-fedora-PF4VCD3F>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <8b998e9f-1d91-6dfd-8065-cfa7a3b19028@huawei.com>
Date: Fri, 12 Jun 2026 13:09:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ainFROZ3WrGioyuY@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk200017.china.huawei.com (7.202.194.83)

[ trim the Cc list ]

Hi Gregory,

On 2026/6/11 4:12, Gregory Price wrote:

> I will still probably send the next RFC version tomorrow or friday,
> as I want to get some eyes on the __GFP_PRIVATE-less pattern.

Could you please Cc me in the next version? I appreciate that and would be
happy to follow this work.

Thanks,
Zenghui
