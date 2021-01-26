From: Tejun Heo <tj@kernel.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Tue, 26 Jan 2021 17:02:32 -0500
Message-ID: <YBCReBXMczop/GQO@slm.duckdns.org>
References: <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
 <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
 <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com>
 <YAopkDN85GtWAj3a@google.com>
 <1744f6c-551b-8de8-263e-5dac291b7ef@google.com>
 <YBCRIPcJyB2J85XS@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gWT03kNJZSWxacIeOv6hjkOlCv2pmh2+pjFjp7VWYGQ=;
        b=po/4EBxBrPQhQy3bPcyEACcYckHeCx+IqagN9LbPD7QWla65XueTFcJcZhFwMJm5q8
         BkPgq90SfW5XB9q4rUfFX6Q3vmRMiuNukJ5gbVAmZ6/0QFvGhiqd98fNfF72QI9cj0Ts
         3ogXVPNT6D3/2J0imMFB6/PEl6R35PvlqLRm2wFIoDdw/AXQE2G1hGL40IY+DVMULxmi
         iCBTlotIA6yDRSNo6CTMqmoQCf0qIGCKYk7YpRU6ooc7Jioj0XEHtleX5dUCur8V8pdh
         ihHDES1CmXI3fZis+DWWDI/VKa2rTH87g2JqBhjS1rzTSOWi+/XOtRg+At/G2P5QzXzb
         b1ww==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YBCRIPcJyB2J85XS@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Tom Lendacky <thomas.lendacky@amd.com>, Vipin Sharma <vipinsh@google.com>, "Singh, Brijesh" <brijesh.singh@amd.com>, "Grimm, Jon" <jon.grimm@amd.com>, "Van Tassell, Eric" <eric.vantassell@amd.com>, pbonzini@redhat.com, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jan 26, 2021 at 05:01:04PM -0500, Tejun Heo wrote:
> * misc.max and misc.current: nested keyed files listing max and current
>   usage for the cgroup.

Keyed files, not nested keyed files.

Thanks.

-- 
tejun
